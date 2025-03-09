import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart'; // ✅ Import the Java Course Page
import 'package:shared_preferences/shared_preferences.dart';

class JavaQ2FinalQuizPage extends StatefulWidget {
  @override
  _JavaQ2FinalQuizPageState createState() => _JavaQ2FinalQuizPageState();
}

class _JavaQ2FinalQuizPageState extends State<JavaQ2FinalQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedAnswerIndex = -1;
  bool _answered = false;

  // Final Quiz Questions
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
    },
    {
      "question": "4. What do you call an error that occurs after compilation of a java program?",
      "options": [
        "A. Syntax error",
        "B. Timing Error",
        "C. Run-time error",
        "D. Program Error"
      ],
      "correct": 0,
    },
    {
      "question": "5. It refers to a free, open source, integrated development environment (IDE) that enables you to develop desktop, mobile and web applications.",
      "options": [
        "A. Syntax Error",
        "B. Netbeans",
        "C. Menu",
        "D. Area"
      ],
      "correct": 1,
    },
  
  ];

  /// Only change: put this INSIDE the State class
  Future<void> _markJavaQ1Completed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("java_q1_completed", true);
  }

  // Handle answer selection
  void _selectAnswer(int selectedIndex) {
    if (_answered) return; // Prevent multiple selections

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _answered = true;

      if (selectedIndex == _questions[_currentQuestionIndex]["correct"]) {
        _score++; // Increase score for correct answers
      }

      // Wait 1 second before moving to next question
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          if (_currentQuestionIndex < _questions.length - 1) {
            _currentQuestionIndex++; // Move to next question
            _selectedAnswerIndex = -1; // Reset selection
            _answered = false;        // Allow new selection
          } else {
            // Last question answered -> Show results
            _showResultsDialog();
          }
        });
      });
    });
  }

  // Show final results & redirect to Java Course Page
  void _showResultsDialog() {
    // Mark Q1 as completed:
    _markJavaQ1Completed();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E3A5F),
        title: Text("Quiz Completed!", style: TextStyle(color: Colors.white)),
        content: Text(
          "You scored $_score out of ${_questions.length}",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text("Finish", style: TextStyle(color: Colors.greenAccent)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => JavaCourseSelectionPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // Score Display
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Score: $_score/${_questions.length}",
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
            ),

            // Animated Progress Bar
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
                    _question(_questions[_currentQuestionIndex]["question"]),
                    SizedBox(height: 10),
                    ...List.generate(
                      _questions[_currentQuestionIndex]["options"].length,
                      (index) => _answerOption(
                        text: _questions[_currentQuestionIndex]["options"][index],
                        index: index,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Title Widget
  Widget _title(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
      ),
    );
  }

  // Question Text Widget
  Widget _question(String question) {
    return Text(
      question,
      style: TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.bold, 
        color: Colors.white
      ),
    );
  }

  // Answer Option Widget (with feedback)
  Widget _answerOption({required String text, required int index}) {
    Color optionColor = Colors.white12; // Default color
    if (_answered) {
      if (index == _questions[_currentQuestionIndex]["correct"]) {
        optionColor = Colors.green; // Correct answer
      } else if (index == _selectedAnswerIndex) {
        optionColor = Colors.red; // Incorrect answer
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
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
