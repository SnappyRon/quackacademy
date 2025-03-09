import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart'; // ✅ Import the Java Course Page
import 'package:shared_preferences/shared_preferences.dart';

class JavaQ1FinalQuizPage extends StatefulWidget {
  @override
  _JavaQ1FinalQuizPageState createState() => _JavaQ1FinalQuizPageState();
}

class _JavaQ1FinalQuizPageState extends State<JavaQ1FinalQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedAnswerIndex = -1;
  bool _answered = false;

  // Final Quiz Questions
  final List<Map<String, dynamic>> _questions = [
    {
      "question": "1. To determine the outcome of your code, one must know?",
      "options": [
        "A. What is the specific problem you want to solve or the task you want it to accomplish?",
        "B. What facts will we learn from the process?",
        "C. What formulas are applicable to the issue at hand?",
        "D. What will be added or no longer exist?"
      ],
      "correct": 0,
    },
    {
      "question": "2. Finding your starting and ending point are crucial to listing the steps of the process. To determine a starting point, determine the answer to these questions, except?",
      "options": [
        "A. What data/inputs are available?",
        "B. Where is that data located?",
        "C. What facts will we learn from the process?",
        "D. What formulas are applicable to the issue at hand?"
      ],
      "correct": 3,
    },
    {
      "question": "3. As with the starting point, you can find the end point of your algorithm by focusing on these questions, except?",
      "options": [
        "A. What facts will we learn from the process?",
        "B. What changes from the start to the end?",
        "C. What will be added or no longer exist?",
        "D. How do the data values relate to each other?"
      ],
      "correct": 3,
    },
    {
      "question": "4. To use a real-world example, let’s say your goal is to have lasagna for dinner. You’ve determined that the starting point is to find a recipe, and that the end result is that you’ll have a lasagna fully cooked and ready to eat by 7 PM. What will you do?",
      "options": [
        "A. Determine how will you accomplish each step.",
        "B. List the steps from start to finish.",
        "C. Find the ending point of the algorithm.",
        "D. Determine the outcome of your code."
      ],
      "correct": 1,
    },
    {
      "question": "5. Now that you’ve written your algorithm, it’s time to evaluate the process by?",
      "options": [
        "A. Review the algorithm.",
        "B. List the steps from start to finish.",
        "C. Find the ending point of the algorithm.",
        "D. Determine how will you accomplish each step."
      ],
      "correct": 0,
    },
    {
      "question": "6. The aim of pseudocode is to make programming easier by using symbols",
      "options": [
        "A. Yes",
        "B. No",
        "C. Maybe",
        "D. All of the above"
      ],
      "correct": 2,
    },
    {
      "question": "7. Is a way of expressing an algorithm without conforming to specific syntactic rules.",
      "options": [
        "A. Pseudocode",
        "B. Data Type",
        "C. Algorithm",
        "D. Flowchart"
      ],
      "correct": 0,
    },
    {
      "question": "8. It is one of the key characteristics which differentiate a human being from other living creatures on the earth",
      "options": [
        "A. Kindness",
        "B. Character",
        "C. Intelligence",
        "D. Beauty"
      ],
      "correct": 2,
    },
    {
      "question": "9. It indicates any type of internal operation inside the processor or memory.",
      "options": [
        "A. Connector",
        "B. Terminal",
        "C. Input/Output",
        "D. Process"
      ],
      "correct": 1,
    },
    {
      "question": "10. It is a data type that holds number with a decimal point.",
      "options": [
        "A. Boolean",
        "B. Interger",
        "C. String",
        "D. Float"
      ],
      "correct": 3,
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
