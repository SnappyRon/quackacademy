import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quackacademy/game/duck_race_game.dart';

class QuizPage extends StatefulWidget {
  final String gameCode;
  final String quizId;

  QuizPage({required this.gameCode, required this.quizId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DuckRaceGame duckRaceGame; // Game instance
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  String currentQuestion = "";
  List<String> currentAnswers = [];
  String? selectedAnswer;
  bool isAnswerSelected = false;

  @override
  void initState() {
    super.initState();
    duckRaceGame = DuckRaceGame();
    _loadQuiz();
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
      });
    }
  }

  void _answerQuestion(String answer) {
    if (isAnswerSelected) return;
    isAnswerSelected = true;

    bool isCorrect = answer == questions[currentIndex]['correctAnswer'];
    if (isCorrect) {
      duckRaceGame.moveDuckForward(); // Move the duck forward
    }

    Future.delayed(Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        _loadQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: Column(
        children: [
          // Game Section
          SizedBox(
            height: 180,
            child: GameWidget(game: duckRaceGame),
          ),

          // Quiz Section
          Expanded(
            child: Column(
              children: [
                // Question
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                
                // Answer Choices
                ...currentAnswers.map((answer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
