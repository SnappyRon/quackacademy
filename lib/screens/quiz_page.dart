import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/duck_race_game.dart';

class QuizPage extends StatefulWidget {
  final String gameCode;
  final String quizId;

  QuizPage({required this.gameCode, required this.quizId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DuckRaceGame duckRaceGame; // The Flame game instance

  // Sample scoreboard data (you can fetch from Firestore in real app)
  final List<Map<String, dynamic>> leaderboard = [
    {"name": "Ron", "points": 15, "place": "1st"},
    {"name": "Edison", "points": 10, "place": "2nd"},
    {"name": "Glady", "points": 9, "place": "3rd"},
  ];

  // Timer & user points (placeholder for your actual logic)
  String timerText = "1:25 min";
  int userPoints = 10;
  String userName = "Edison";

  // Quiz data
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  String currentQuestion = "";
  List<String> currentAnswers = [];

  // Track chosen answer for coloring
  String? selectedAnswer;
  bool isAnswerSelected = false;

  @override
  void initState() {
    super.initState();
    duckRaceGame = DuckRaceGame();
    _loadQuiz();
  }

  void _loadQuiz() async {
    // Load questions from Firestore
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
      });
    }
  }

  void _answerQuestion(String answer) {
    if (isAnswerSelected) return;
    isAnswerSelected = true;

    final correctAnswer = questions[currentIndex]['correctAnswer'];
    bool isCorrect = (answer == correctAnswer);

    setState(() {
      selectedAnswer = answer;
    });

    // Move user duck if correct
    if (isCorrect) {
      duckRaceGame.moveUserDuckForward();
    }

    // Next question after delay
    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        _loadQuestion();
      });
    } else {
      // End of quiz logic
    }
  }

  @override
  Widget build(BuildContext context) {
    // If you want to show question index (like "3/10")
    String questionIndexText = "${currentIndex + 1}/${questions.length}";

    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // 1) Leaderboard Row
            Container(
              color: Colors.blue.shade800,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: leaderboard.map((entry) {
                  return Column(
                    children: [
                      Text(
                        entry['place'], // e.g. "1st"
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        entry['name'],
                        style: GoogleFonts.poppins(
                          color: Colors.yellow,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${entry['points']} pts",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            // 2) The Duck Race game
            SizedBox(
              height: 200,
              child: GameWidget(game: duckRaceGame),
            ),

            // 3) Question Index & Text
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

            // 4) Answer Choices
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

            // 5) Bottom Row: Timer & user’s points
            Container(
              color: Colors.blue.shade900,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timer
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        timerText, // e.g. "1:25 min"
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  // User Name + Points
                  Text(
                    "$userName  $userPoints Pts",
                    style: GoogleFonts.poppins(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single answer button with dynamic color
  Widget _buildAnswerButton(String answer) {
    if (questions.isEmpty) {
      return Container();
    }
    final correctAnswer = questions[currentIndex]['correctAnswer'];
    bool isChosen = (selectedAnswer == answer);
    bool isCorrect = (answer == correctAnswer);

    // Decide button color
    Color buttonColor = Colors.orange; // default
    if (selectedAnswer != null && isChosen) {
      // If the user has chosen this answer
      if (isCorrect) {
        buttonColor = Colors.red; // chosen correct => red
      } else {
        buttonColor = Colors.grey; // chosen wrong => gray
      }
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
