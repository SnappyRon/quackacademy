import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

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

  /// The Flame game instance
  late DuckRaceGame duckRaceGame;

  /// Streams for dynamic leaderboard
  late Stream<QuerySnapshot> _top3Stream;
  late Stream<QuerySnapshot> _fullLeaderboardStream;
  late Stream<DocumentSnapshot> _currentUserStream;

  /// Local map of playerId -> old points (to detect increments)
  Map<String, int> _previousPoints = {};

  /// Quiz data (only relevant for students)
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  String currentQuestion = "";
  List<String> currentAnswers = [];
  String? selectedAnswer;
  bool isAnswerSelected = false;

  /// Timer (15 minutes)
  late Timer _timer;
  int _remainingSeconds = 15 * 60; // 900 seconds

  @override
  void initState() {
    super.initState();

    duckRaceGame = DuckRaceGame();

    // If not teacher, load quiz slides
    if (!widget.isTeacher) {
      _loadQuiz();
    }

    // 1) Top 3 players for duck assignments & to detect increments
    _top3Stream = _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .orderBy('points', descending: true)
        .limit(3)
        .snapshots();

    // 2) Full leaderboard (for teacher UI)
    _fullLeaderboardStream = _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .orderBy('points', descending: true)
        .snapshots();

    // 3) Current user doc (for bottom bar)
    _currentUserStream = _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(widget.currentPlayerId)
        .snapshots();

    // Start the 15-min countdown
    _startTimer();
  }

  /// Load up to 10 questions (students only)
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

  /// Load the current question + answers
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

  /// Timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          // End-of-quiz logic if needed
        }
      });
    });
  }

  String get timerText {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')} min";
  }

  /// Student answering a question
  void _answerQuestion(String answer) async {
    if (isAnswerSelected) return;
    setState(() {
      isAnswerSelected = true;
      selectedAnswer = answer;
    });

    final correctAnswer = questions[currentIndex]['correctAnswer'];
    bool isCorrect = (answer == correctAnswer);

    if (isCorrect) {
      // Increment Firestore points
      await _firestore
          .collection('rooms')
          .doc(widget.gameCode)
          .collection('players')
          .doc(widget.currentPlayerId)
          .update({
        'points': FieldValue.increment(1),
      });

      // Move local duck (for student view)
      duckRaceGame.moveDuckForPlayer(widget.currentPlayerId);
    }

    // Next question after short delay
    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  /// Go to the next question or end the quiz
  void _nextQuestion() {
  if (currentIndex < questions.length - 1) {
    setState(() {
      currentIndex++;
      _loadQuestion();
    });

    // If we are at the 2nd-to-last question (index == length - 2),
    // start scrolling the finish line:
    if (currentIndex == questions.length - 2) {
      duckRaceGame.startFinishLineScrolling = true;
    }
  } else {
    // Last question answered
    _timer.cancel();

    // Optionally trigger the finish line to scroll if you want it to appear at the very last
    // duckRaceGame.startFinishLineScrolling = true;

    if (!widget.isTeacher) {
      _showEndOfQuizDialog();
    }
  }
}


  /// Show a dialog with "Congratulations" + final points + rank
  Future<void> _showEndOfQuizDialog() async {
    // 1) Get the current player's final points from Firestore
    final playerDoc = await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(widget.currentPlayerId)
        .get();

    if (!playerDoc.exists) return; // safety check

    final data = playerDoc.data() as Map<String, dynamic>;
    final finalPoints = data['points'] ?? 0;

    // 2) Get the entire leaderboard to find the player's rank
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
        rankIndex = i; // 0-based index
        break;
      }
    }
    final placeNumber = rankIndex + 1; // 1-based rank

    // 3) Show a dialog
    String placeSuffix = "th";
    if (placeNumber == 1) placeSuffix = "st";
    else if (placeNumber == 2) placeSuffix = "nd";
    else if (placeNumber == 3) placeSuffix = "rd";

    String title = "Congratulations!";
    String content =
        "You have finished the quiz.\n"
        "Your final score is $finalPoints points.\n"
        "You got $placeNumber$placeSuffix place!";

    showDialog(
      context: context,
      barrierDismissible: false, // user must tap OK
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // close the dialog
                // You could also pop the QuizPage if you want:
                // Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
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
            // 1) Top 3 Header + Stream
            _buildTop3Header(),

            // 2) Duck Race
            SizedBox(
              height: 200,
              child: GameWidget(game: duckRaceGame),
            ),

            // 3) Middle Content
            Expanded(
              child: widget.isTeacher
                  ? _buildTeacherLeaderboard()
                  : _buildStudentQuiz(),
            ),

            // 4) Bottom Bar
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

          // Convert docs to a List<Map> with id, name, points
          for (var doc in docs) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            topPlayers.add(data);
          }

          // 1) Update ducks with the new top 3
          duckRaceGame.updateDucks(topPlayers);

          // 2) Detect if any player's points increased => move duck
          for (var p in topPlayers) {
            String playerId = p['id'];
            int newPoints = p['points'] ?? 0;
            int oldPoints = _previousPoints[playerId] ?? 0;

            if (newPoints > oldPoints) {
              // Points incremented
              int diff = newPoints - oldPoints; // how many increments
              for (int i = 0; i < diff; i++) {
                duckRaceGame.moveDuckForPlayer(playerId);
              }
            }

            // Update _previousPoints
            _previousPoints[playerId] = newPoints;
          }

          // Also remove old entries from _previousPoints if they are no longer in top 3
          // (Optional: depends if you want to keep track of them or not)
          final top3Ids = topPlayers.map((p) => p['id']).toSet();
          _previousPoints.removeWhere((k, v) => !top3Ids.contains(k));

          // 3) Build the UI row
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

  /// Teacher sees full leaderboard
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

  /// Student sees the quiz (question + answers)
  Widget _buildStudentQuiz() {
    if (questions.isEmpty) {
      return Center(
        child: Text(
          "No quiz data...",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      );
    }

    String questionIndexText = "${currentIndex + 1}/${questions.length}";

    return Column(
      children: [
        // Question index
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            questionIndexText,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        // Question text
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            currentQuestion,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
        // Answers
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: currentAnswers.length,
            itemBuilder: (context, index) {
              String answer = currentAnswers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: _buildAnswerButton(answer),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Bottom bar: Timer + user’s points
  Widget _buildBottomBar() {
    return Container(
      color: Colors.blue.shade900,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    timerText,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Text(
                "$userName  $userPoints Pts",
                style: GoogleFonts.poppins(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// A single answer button
  Widget _buildAnswerButton(String answer) {
    final correctAnswer = questions[currentIndex]['correctAnswer'];
    bool isChosen = (selectedAnswer == answer);
    bool isCorrect = (answer == correctAnswer);
    Color buttonColor = Colors.orange;
    if (selectedAnswer != null && isChosen) {
      buttonColor = isCorrect ? Colors.red : Colors.grey;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      ),
      onPressed: () => _answerQuestion(answer),
      child: Text(
        answer,
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }
}
