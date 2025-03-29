import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';
import 'package:quackacademy/services/exp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JavaQ2FinalQuizPage extends StatefulWidget {
  @override
  _JavaQ2FinalQuizPageState createState() => _JavaQ2FinalQuizPageState();
}

class _JavaQ2FinalQuizPageState extends State<JavaQ2FinalQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedAnswerIndex = -1;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "1. What are the elements of Netbeans’ control area?",
      "options": [
        "A. main menu bar, quick launch bar, search tool",
        "B. reference area, main menu bar",
        "C. working area, search tool",
        "D. status area, working area"
      ],
      "correct": 0,
      "feedback": [
        "Correct! These are the main control elements of NetBeans.",
        "Incorrect. Reference area is not part of the control area.",
        "Incorrect. Working area is part of the workspace, not control.",
        "Incorrect. Status and working areas are not in the control section."
      ],
    },
    {
      "question": "2. It refers to errors that will not display until you run or executes the program.",
      "options": [
        "A. Syntax error",
        "B. Timing Error",
        "C. Run-time error",
        "D. Program Error"
      ],
      "correct": 2,
      "feedback": [
        "Incorrect. Syntax errors are caught before execution.",
        "Incorrect. Timing errors are not typical programming terminology.",
        "Correct! Run-time errors appear only when the code runs.",
        "Incorrect. This is a general term, not specific."
      ],
    },
    {
      "question": "3. It shows you the insert/overwriting status, cursor coordinates, upgrading status and some other info.",
      "options": [
        "A. Reference area",
        "B. Working Area",
        "C. Status Area",
        "D. Main Menu"
      ],
      "correct": 2,
      "feedback": [
        "Incorrect. Reference area is where libraries or docs are shown.",
        "Incorrect. Working area is where you code, not where status appears.",
        "Correct! The status area shows that kind of real-time information.",
        "Incorrect. The main menu holds navigation and options."
      ],
    },
    {
      "question": "4. What do you call an error that occurs after compilation of a java program?",
      "options": [
        "A. Syntax error",
        "B. Timing Error",
        "C. Run-time error",
        "D. Program Error"
      ],
      "correct": 2,
      "feedback": [
        "Incorrect. Syntax errors prevent compilation.",
        "Incorrect. Timing error isn't the right term here.",
        "Correct! Run-time errors occur after compilation, during execution.",
        "Incorrect. This is too general of a term."
      ],
    },
    {
      "question": "5. It refers to a free, open source IDE enabling you to develop desktop, mobile, web apps.",
      "options": ["A. Syntax Error", "B. Netbeans", "C. Menu", "D. Area"],
      "correct": 1,
      "feedback": [
        "Incorrect. That’s an error type, not an IDE.",
        "Correct! NetBeans is the free open-source IDE in question.",
        "Incorrect. A menu is a UI element, not an IDE.",
        "Incorrect. 'Area' is not a specific tool or software."
      ],
    },
  ];

  Future<bool> _markJavaQ2Completed() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final String userQ2Key = "java_q2_completed_${user.uid}";
    final String expAwardedKey = "java_q2_exp_awarded_${user.uid}";

    bool alreadyCompleted = prefs.getBool(userQ2Key) ?? false;
    bool expAlreadyAwarded = prefs.getBool(expAwardedKey) ?? false;

    if (!alreadyCompleted) {
      await prefs.setBool(userQ2Key, true);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({"completedLessons": FieldValue.increment(1)});
    }

    if (!expAlreadyAwarded) {
      await ExpService.awardExp(50);
      await prefs.setBool(expAwardedKey, true);
      return true;
    }

    return false;
  }

  void _selectAnswer(int selectedIndex) {
    if (_answered) return;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _answered = true;

      if (selectedIndex == _questions[_currentQuestionIndex]["correct"]) {
        _score++;
      }

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          if (_currentQuestionIndex < _questions.length - 1) {
            _currentQuestionIndex++;
            _selectedAnswerIndex = -1;
            _answered = false;
          } else {
            _showResultsDialog();
          }
        });
      });
    });
  }

  void _showResultsDialog() async {
    bool newlyAwardedExp = await _markJavaQ2Completed();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E3A5F),
        title: Text("Quiz Completed!", style: TextStyle(color: Colors.white)),
        content: Text(
          newlyAwardedExp
              ? "Congratulations! You've earned +50 EXP.\n\nYou scored $_score out of ${_questions.length}."
              : "You scored $_score out of ${_questions.length}.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text("Finish", style: TextStyle(color: Colors.greenAccent)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => JavaCourseSelectionPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _feedbackWidget() {
    if (!_answered) return SizedBox.shrink();

    final feedback = _questions[_currentQuestionIndex]["feedback"][_selectedAnswerIndex];

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        feedback,
        style: const TextStyle(fontSize: 16, color: Colors.yellowAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Score: $_score/${_questions.length}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: 8,
                    width: MediaQuery.of(context).size.width *
                        ((_currentQuestionIndex + 1) / _questions.length),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            _title("FINAL QUIZ"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _question(current["question"]),
                    SizedBox(height: 10),
                    ...List.generate(
                      current["options"].length,
                      (index) => _answerOption(
                        text: current["options"][index],
                        index: index,
                      ),
                    ),
                    _feedbackWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _question(String question) {
    return Text(
      question,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _answerOption({required String text, required int index}) {
    Color optionColor = Colors.white12;
    if (_answered) {
      if (index == _questions[_currentQuestionIndex]["correct"]) {
        optionColor = Colors.green;
      } else if (index == _selectedAnswerIndex) {
        optionColor = Colors.red;
      }
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: optionColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white38),
        ),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
