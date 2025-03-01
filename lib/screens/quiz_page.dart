import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class QuizPage extends StatefulWidget {
  final String gameCode;
  final String quizId;

  QuizPage({required this.gameCode, required this.quizId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  Map<String, int> playerScores = {};
  Map<String, double> playerPositions = {};
  Timer? _timer;
  int timeLeft = 90;
  String? selectedAnswer;
  String currentQuestion = "";
  List<String> currentAnswers = [];
  List<String> topPlayers = [];
  bool isAnswerSelected = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
    _fetchPlayerData();
  }

  void _loadQuiz() async {
    QuerySnapshot quizSnapshot = await _firestore
        .collection('quizzes')
        .doc(widget.quizId)
        .collection('slides')
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

  void _loadQuestion() {
    if (currentIndex < questions.length) {
      setState(() {
        currentQuestion = questions[currentIndex]['question'];
        currentAnswers = List<String>.from(questions[currentIndex]['answers']);
        selectedAnswer = null;
        isAnswerSelected = false;
        _startTimer();
      });
    } else {
      _endGame();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    timeLeft = 90;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        _timer?.cancel();
        _nextQuestion();
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void _fetchPlayerData() {
    _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        playerScores = {};
        playerPositions = {};
        for (var doc in snapshot.docs) {
          String name = doc['name'];
          int score = doc['score'] ?? 0;
          playerScores[name] = score;
          playerPositions[name] = (score / 100).toDouble();
        }

        topPlayers = playerScores.keys.toList()
          ..sort((a, b) => playerScores[b]!.compareTo(playerScores[a]!));
        if (topPlayers.length > 3) {
          topPlayers = topPlayers.sublist(0, 3);
        }
      });
    });
  }

  void _answerQuestion(String answer) {
    if (isAnswerSelected) return;
    isAnswerSelected = true;

    bool isCorrect = answer == questions[currentIndex]['correctAnswer'];
    if (isCorrect) {
      _updateScore();
    }

    setState(() {
      selectedAnswer = answer;
    });

    Future.delayed(Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _updateScore() async {
    String playerName = "YourPlayerName"; // Replace with actual player name
    int newScore = (playerScores[playerName] ?? 0) + 10;

    await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(playerName)
        .update({'score': newScore});
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        _loadQuestion();
      });
    } else {
      _endGame();
    }
  }

  void _endGame() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _buildLeaderboard(),
            _buildDuckRace(),
            _buildQuizSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.blue.shade800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: topPlayers.asMap().entries.map((entry) {
          int index = entry.key;
          String player = entry.value;
          int score = playerScores[player] ?? 0;
          return Column(
            children: [
              Text(
                "${index + 1}st",
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                player,
                style: GoogleFonts.poppins(color: Colors.yellow, fontSize: 16),
              ),
              Text(
                "$score pts",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDuckRace() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/water_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: topPlayers.map((player) {
          double position = playerPositions[player] ?? 0.0;
          return Positioned(
            left: MediaQuery.of(context).size.width * position,
            top: 50.0 * topPlayers.indexOf(player),
            child: _buildDuck(player),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDuck(String playerName) {
    return Column(
      children: [
        Image.asset('assets/images/duck.png', height: 50),
        Text(
          playerName,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildQuizSection() {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              currentQuestion,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 22),
            ),
          ),
          ...currentAnswers.map((answer) {
            bool isCorrect = selectedAnswer != null &&
                answer == questions[currentIndex]['correctAnswer'];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedAnswer == answer
                      ? isCorrect
                          ? Colors.green
                          : Colors.red
                      : Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
                onPressed: () => _answerQuestion(answer),
                child: Text(answer, style: GoogleFonts.poppins(color: Colors.white)),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
