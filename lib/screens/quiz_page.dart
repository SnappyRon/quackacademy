import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quackacademy/screens/leaderboard_page.dart';

import '../game/duck_race_game.dart';

class QuizPage extends StatefulWidget {
  final String gameCode;
  final String quizId;
  final String currentPlayerId;
  final bool isTeacher; // If true, show teacher UI (full leaderboard, etc.)

  QuizPage({
    required this.gameCode,
    required this.quizId,
    required this.currentPlayerId,
    required this.isTeacher,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// The Flame game instance.
  late DuckRaceGame duckRaceGame;

  /// Streams for dynamic leaderboard.
  late Stream<QuerySnapshot> _top3Stream;
  late Stream<QuerySnapshot> _fullLeaderboardStream;
  late Stream<DocumentSnapshot> _currentUserStream;

  /// Local map of playerId -> old points (to detect increments).
  Map<String, int> _previousPoints = {};

  /// Quiz data (only relevant for students).
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  String currentQuestion = "";
  List<String> currentAnswers = [];
  String? selectedAnswer;
  bool isAnswerSelected = false;

  String? _feedbackMessage;

  /// Timer (15 minutes).
  late Timer _timer;
  int _remainingSeconds = 15 * 60; // 900 seconds

  /// Flag to indicate that the quiz is finished and finish line is showing.
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();

    duckRaceGame = DuckRaceGame();

    // For students: load quiz slides and listen to quiz status changes.
    if (!widget.isTeacher) {
      _loadQuiz();
      _listenToQuizStatus();
    }

    // 1) Top 3 players for duck assignments & to detect increments.
    _top3Stream = _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .orderBy('points', descending: true)
        .limit(3)
        .snapshots();

    // 2) Full leaderboard (for teacher UI).
    _fullLeaderboardStream = _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .orderBy('points', descending: true)
        .snapshots();

    // 3) Current user doc (for bottom bar).
    _currentUserStream = _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(widget.currentPlayerId)
        .snapshots();

    // Start the 15-min countdown.
    _startTimer();
  }

  /// Listen to room's quizStatus changes (for students).
  void _listenToQuizStatus() {
    _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .snapshots()
        .listen((docSnapshot) async {
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        if (data['quizStatus'] == 'stopped') {
          // Before redirecting, record the student's result.
          final playerDoc = await _firestore
              .collection('rooms')
              .doc(widget.gameCode)
              .collection('players')
              .doc(widget.currentPlayerId)
              .get();

          if (playerDoc.exists) {
            final playerData = playerDoc.data() as Map<String, dynamic>;
            final finalPoints = playerData['points'] ?? 0;
            final playerName = playerData['name'] ?? 'Player';
            final playerImage =
                playerData['image'] ?? 'assets/images/Student1.png';

            // Get quiz title from quizzes collection.
            DocumentSnapshot quizDoc =
                await _firestore.collection('quizzes').doc(widget.quizId).get();
            String quizTitle =
                (quizDoc.data() as Map<String, dynamic>)['title'] ??
                    'Quiz Session';

            // Write/update the studentHistory document.
            await _firestore.collection('studentHistory').add({
              'studentId': widget.currentPlayerId,
              'quizId': widget.quizId,
              'quizTitle': quizTitle,
              'name': playerName,
              'score': finalPoints,
              'image': playerImage,
              'finished': true,
              'timestamp': FieldValue.serverTimestamp(),
            });
          }
          // Now show the dialog and redirect.
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Quiz Stopped"),
                content: Text(
                    "The teacher has stopped the quiz. You will now be redirected to the leaderboard."),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LeaderboardPage(
                            isTeacher: false,
                            currentPlayerId: widget.currentPlayerId,
                            quizId: widget.quizId,
                            gameCode: widget.gameCode,
                          ),
                        ),
                      );
                    },
                    child: Text("OK",
                        style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  /// Load up to 10 questions (students only).
  void _loadQuiz() async {
    final quizSnapshot = await _firestore
        .collection('quizzes')
        .doc(widget.quizId)
        .collection('slides')
        .limit(10)
        .get();

    setState(() {
      questions = quizSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (questions.isNotEmpty) {
        _loadQuestion();
      }
    });
  }

  /// Load the current question + answers.
  void _loadQuestion() {
    if (currentIndex < questions.length) {
      setState(() {
        currentQuestion = questions[currentIndex]['question'] ?? '';
        currentAnswers =
            List<String>.from(questions[currentIndex]['answers'] ?? []);
        selectedAnswer = null;
        isAnswerSelected = false;
      });
    }
  }

  /// Timer.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          // End-of-quiz logic if needed.
        }
      });
    });
  }

  String get timerText {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')} min";
  }

  /// Student answering a question.
  void _answerQuestion(String answer) async {
    if (isAnswerSelected) return;

    // Mark the answer as selected.
    setState(() {
      isAnswerSelected = true;
      selectedAnswer = answer;
    });

    // Get the correct answer from the current question.
    final correctAnswer =
        questions[currentIndex]['correctAnswer'].toString().trim();
    bool isCorrect = answer.toString().trim() == correctAnswer;

    // If the answer is wrong, set the feedback message.
    if (!isCorrect) {
      setState(() {
        _feedbackMessage = "Incorrect! The correct answer is: $correctAnswer";
      });
    } else {
      // Clear any previous feedback.
      setState(() {
        _feedbackMessage = null;
      });
    }

    if (isCorrect) {
      // Increment Firestore points.
      await _firestore
          .collection('rooms')
          .doc(widget.gameCode)
          .collection('players')
          .doc(widget.currentPlayerId)
          .update({
        'points': FieldValue.increment(1),
      });

      // Move local duck (for student view).
      duckRaceGame.moveDuckForPlayer(widget.currentPlayerId);
    }

    // Delay for 3 seconds to let the user see the feedback before moving on.
    Future.delayed(const Duration(seconds: 3), () {
      _nextQuestion();
    });
  }

  /// Go to the next question or end the quiz.
  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        // Reset answer state and feedback for the next question.
        selectedAnswer = null;
        isAnswerSelected = false;
        _feedbackMessage = null;
        _loadQuestion();

        if (currentIndex == questions.length - 1) {
          duckRaceGame.startFinishLineScrolling = true;
          duckRaceGame.finishLine?.position.x = duckRaceGame.finishLineBaseX;
        }
      });
    } else {
      print('DEBUG: Reached last question!');
      duckRaceGame.startFinishLineScrolling = true;
      _timer.cancel();
      setState(() {
        _quizFinished = true;
      });
    }
  }

  /// Mark player as finished and show end-of-quiz dialog (for students).
  Future<void> _showEndOfQuizDialog() async {
    print('DEBUG: Inside _showEndOfQuizDialog()...');
    // Get the current player's final points from Firestore.
    final playerDoc = await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(widget.currentPlayerId)
        .get();

    if (!playerDoc.exists) {
      print('DEBUG: Player doc does NOT exist, returning...');
      return; // safety check.
    }
    print('DEBUG: Player doc DOES exist, continuing...');

    final data = playerDoc.data() as Map<String, dynamic>;
    final finalPoints = data['points'] ?? 0;
    final playerName = data['name'] ?? 'Player';
    final playerImage = data['image'] ?? 'assets/images/Student1.png';

    // Mark the player as finished.
    await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(widget.currentPlayerId)
        .update({
      'finished': true,
    });

    // Update the leaderboard Firestore collection with this player's data.
    // Get the quiz title from the quizzes collection.
    DocumentSnapshot quizDoc =
        await _firestore.collection('quizzes').doc(widget.quizId).get();
    String quizTitle =
        (quizDoc.data() as Map<String, dynamic>)['title'] ?? 'Quiz Session';

    // Write a new document into the "studentHistory" collection.
    await _firestore.collection('studentHistory').add({
      'studentId': widget.currentPlayerId,
      'quizId': widget.quizId,
      'quizTitle': quizTitle,
      'name': playerName,
      'score': finalPoints,
      'image': playerImage,
      'finished': true,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Get the entire leaderboard to find the player's rank.
    final allPlayersSnapshot = await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .orderBy('points', descending: true)
        .get();

    int rankIndex = -1;
    final docs = allPlayersSnapshot.docs;
    for (int i = 0; i < docs.length; i++) {
      if (docs[i].id == widget.currentPlayerId) {
        rankIndex = i; // 0-based index.
        break;
      }
    }
    final placeNumber = rankIndex + 1; // 1-based rank.

    // Set the proper suffix for the place number.
    String placeSuffix = "th";
    if (placeNumber == 1)
      placeSuffix = "st";
    else if (placeNumber == 2)
      placeSuffix = "nd";
    else if (placeNumber == 3) placeSuffix = "rd";

    // Schedule showing the dialog after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        context: context,
        barrierDismissible: false, // user must tap OK.
        builder: (ctx) {
          return AlertDialog(
            title: Text("Congratulations!"),
            content: Text(
              "You have finished the quiz.\n"
              "Your final score is $finalPoints points.\n"
              "You got $placeNumber$placeSuffix place!",
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(); // close the dialog.
                },
                child:
                    Text("OK", style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          );
        },
      );

      // After the dialog, navigate to the leaderboard (for students).
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LeaderboardPage(
              isTeacher: false,
              currentPlayerId: widget.currentPlayerId,
              quizId: widget.quizId,
              gameCode: widget.gameCode,
            ),
          ),
        );
      }
    });
  }

  /// Teacher stops the quiz manually.
  Future<void> _stopQuiz() async {
    // Update the room's quiz status.
    await _firestore.collection('rooms').doc(widget.gameCode).update({
      'quizStatus': 'stopped',
    });
    _timer.cancel();

    // Retrieve the quiz title from the quizzes collection.
    DocumentSnapshot quizDoc =
        await _firestore.collection('quizzes').doc(widget.quizId).get();
    String quizTitle =
        (quizDoc.data() as Map<String, dynamic>)['title'] ?? 'Quiz Session';

    // Create a new quiz session document in "quizSessions".
    DocumentReference sessionRef =
        await _firestore.collection('quizSessions').add({
      'quizTitle': quizTitle,
      'date': FieldValue.serverTimestamp(),
      'gameCode': widget.gameCode, // optional
    });

    // Get all players in the current game room.
    QuerySnapshot playersSnapshot = await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .get();

    // For each player, add their result into the session's "leaderboard" subcollection.
    for (var playerDoc in playersSnapshot.docs) {
      final playerData = playerDoc.data() as Map<String, dynamic>;
      await sessionRef.collection('leaderboard').doc(playerDoc.id).set({
        'name': playerData['name'] ?? '',
        'score': playerData['points'] ?? 0,
        'finished': playerData['finished'] ?? false,
        'image': playerData['image'] ?? 'assets/images/Student1.png',
      });
    }

    // Navigate to the LeaderboardPage (teacher view) for sessions.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderboardPage(
          isTeacher: true,
          currentPlayerId: widget.currentPlayerId,
          quizId: sessionRef.id,
          gameCode: widget.gameCode, // pass the session id if needed
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // Teacher control row: Stop Quiz button and finished indicator.
            if (widget.isTeacher)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 40),
                      ),
                      onPressed: _stopQuiz,
                      child: Text("Stop Quiz",
                          style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('rooms')
                          .doc(widget.gameCode)
                          .collection('players')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();
                        final finishedCount = snapshot.data!.docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['finished'] == true;
                        }).length;
                        return Text(
                          "$finishedCount finished",
                          style: GoogleFonts.poppins(color: Colors.white),
                        );
                      },
                    ),
                  ],
                ),
              ),
            // 1) Top 3 Header + Stream.
            _buildTop3Header(),

            // 2) Duck Race.
            SizedBox(
              height: 200,
              child: GameWidget(game: duckRaceGame),
            ),

            // 3) Middle Content.
            Expanded(
              child: widget.isTeacher
                  ? _buildTeacherLeaderboard()
                  : _buildStudentQuiz(),
            ),

            // Show "Continue" button if the quiz is finished (for students).
            if (_quizFinished && !widget.isTeacher)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: _showEndOfQuizDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Continue",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),

            // 4) Bottom Bar.
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  /// Displays top 3 players horizontally + calls `updateDucks()`.
  /// Also detects points increments to move ducks for teacher.
  Widget _buildTop3Header() {
    return Container(
      color: Colors.blue.shade800,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder<QuerySnapshot>(
        stream: _top3Stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Loading top 3...",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            );
          }
          final docs = snapshot.data!.docs;
          List<Map<String, dynamic>> topPlayers = [];

          // Convert docs to a List<Map> with id, name, points.
          for (var doc in docs) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            topPlayers.add(data);
          }

          // Update ducks with the new top 3.
          duckRaceGame.updateDucks(topPlayers);

          // Detect if any player's points increased => move duck.
          for (var p in topPlayers) {
            String playerId = p['id'];
            int newPoints = p['points'] ?? 0;
            int oldPoints = _previousPoints[playerId] ?? 0;

            if (newPoints > oldPoints) {
              int diff = newPoints - oldPoints; // how many increments.
              for (int i = 0; i < diff; i++) {
                duckRaceGame.moveDuckForPlayer(playerId);
              }
            }

            // Update _previousPoints.
            _previousPoints[playerId] = newPoints;
          }

          // Remove old entries from _previousPoints if they are no longer in top 3.
          final top3Ids = topPlayers.map((p) => p['id']).toSet();
          _previousPoints.removeWhere((k, v) => !top3Ids.contains(k));

          // Build the UI row.
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Player';
              final points = data['points'] ?? 0;
              final rankIndex = docs.indexOf(doc);
              String placeLabel = "";
              switch (rankIndex) {
                case 0:
                  placeLabel = "1st";
                  break;
                case 1:
                  placeLabel = "2nd";
                  break;
                case 2:
                  placeLabel = "3rd";
                  break;
              }
              return Column(
                children: [
                  Text(
                    placeLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      color: Colors.yellow,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "$points pts",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  /// Teacher sees full leaderboard.
  Widget _buildTeacherLeaderboard() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fullLeaderboardStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Loading leaderboard...",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          );
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return Center(
            child: Text(
              "No players yet!",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Player';
              final points = data['points'] ?? 0;
              return ListTile(
                title: Text(
                  "#${index + 1}  $name",
                  style: GoogleFonts.poppins(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  "$points pts",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Student sees the quiz (question + answers).
  Widget _buildStudentQuiz() {
    if (questions.isEmpty) {
      return Center(
        child: Text(
          "No quiz data...",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      );
    }

    // e.g. "1/5"
    final questionIndexText = "${currentIndex + 1}/${questions.length}";
    // The question text
    final questionText = currentQuestion;

    return Column(
      children: [
        // Question Card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question index text
              Text(
                questionIndexText,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // The question text
              Text(
                questionText,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Answers + Feedback area
        Expanded(
          child: Column(
            children: [
              // The answer grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    // Increase childAspectRatio to make boxes bigger
                    // e.g. 1.5, 1.8, or 2.0 depending on how large you want them
                    childAspectRatio: 1.6,
                    children: currentAnswers.map((answer) {
                      return _buildAnswerButton(answer);
                    }).toList(),
                  ),
                ),
              ),

              // Feedback message EXACTLY below the answers
              if (_feedbackMessage != null)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 4.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Text(
                    _feedbackMessage!,
                    style: GoogleFonts.poppins(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Bottom bar: Timer + user’s points.
  Widget _buildBottomBar() {
    // Calculate fraction of time left (optional, if you want a partial fill).
    // 15*60 = 900 seconds if you have a 15-minute timer.
    double fractionLeft = _remainingSeconds / (15.0 * 60.0);
    if (fractionLeft < 0) fractionLeft = 0; // safety clamp

    return Container(
      // Background color behind everything (if desired).
      color: const Color(0xFF1A3A5F),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: StreamBuilder<DocumentSnapshot>(
        stream: _currentUserStream,
        builder: (context, snapshot) {
          String userName = "Loading...";
          int userPoints = 0;
          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            userName = data['name'] ?? 'You';
            userPoints = data['points'] ?? 0;
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1) Timer Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4C9AFF), // Blue pill background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The time text, e.g. "1:25 min"
                    Text(
                      timerText,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Partial fill bar to show time left (optional)
                    Stack(
                      children: [
                        // Background bar (fixed width)
                        Container(
                          width: 50,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        // Foreground fill
                        Container(
                          width:
                              50 * fractionLeft, // fraction of the total width
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2) Name + Points
              Row(
                children: [
                  // Name in orange
                  Text(
                    userName,
                    style: GoogleFonts.poppins(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // White rectangle for points
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$userPoints Pts",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// A single answer button.
  Widget _buildAnswerButton(String answer) {
    // Use trimmed strings to avoid whitespace mismatches.
    final correctAnswer =
        questions[currentIndex]['correctAnswer'].toString().trim();
    final trimmedAnswer = answer.toString().trim();
    final chosenAnswer = selectedAnswer?.toString().trim();

    // Default color for unselected answers.
    Color buttonColor = const Color(0xFF476F95);

    if (selectedAnswer != null) {
      // If this button's answer equals the correct answer, set to green.
      if (trimmedAnswer == correctAnswer) {
        buttonColor = const Color.fromARGB(255, 11, 203, 107); // green
      }
      // But if this button is the one the user chose and it's not correct, override with red.
      if (chosenAnswer == trimmedAnswer && trimmedAnswer != correctAnswer) {
        buttonColor = const Color.fromARGB(255, 238, 48, 0); // red
      }
    }

    // Debug print to verify comparisons.
    print(
        "Rendering answer: '$trimmedAnswer' | selected: '$chosenAnswer' | correct: '$correctAnswer' | color: $buttonColor");

    return ElevatedButton(
      key: ValueKey(trimmedAnswer), // Forces rebuild per answer.
      onPressed: selectedAnswer != null ? null : () => _answerQuestion(answer),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        disabledBackgroundColor:
            buttonColor, // Ensures the button keeps the color when disabled.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Increase vertical and horizontal padding to make the box larger.
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      child: Text(
        answer,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14, // Adjusted font size for better fit
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
