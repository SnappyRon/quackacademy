import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JavaFinalQuizPage extends StatefulWidget {
  @override
  _JavaFinalQuizPageState createState() => _JavaFinalQuizPageState();
}
Future<void> _markJavaQ3Completed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("java_q3_completed", true);
}

class _JavaFinalQuizPageState extends State<JavaFinalQuizPage> {
  Map<int, String?> _selectedAnswers = {};
  Map<int, bool?> _answerCorrectness = {};

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "1. The Java declaration for String msg=\"Hello World!\";",
      "options": ["True", "False"],
      "answer": "True"
    },
    {
      "question": "2. The Java declaration\n\nint a=80; b=85; c=90; int grade; grade = (a+b+c)/3;\nSystem.out.println(\"The Final Grade:\"+grade);",
      "options": ["True", "False"],
      "answer": "True"
    },
    {
      "question": "3. The Java language has no compiler.",
      "options": ["True", "False"],
      "answer": "False"
    },
    {
      "question": "4. The library import java.io.* : io means input output.",
      "options": ["True", "False"],
      "answer": "True"
    },
    {
      "question": "5. The value a=73; b=75; g=(a+b)/2; If g >75; remarks =\"True\" else remarks =\"False\".",
      "options": ["True", "False"],
      "answer": "False"
    },
  ];

  final TextEditingController _wrapUpAnswer1 = TextEditingController();
  final TextEditingController _wrapUpAnswer2 = TextEditingController();

  void _submitQuiz() {
  int correctAnswers = 0;
  _questions.asMap().forEach((index, questionData) {
    if (_selectedAnswers[index] == questionData["answer"]) {
      correctAnswers++;
    }
  });

  // Mark the Q3 as completed
  _markJavaQ3Completed();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Quiz Results"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("You got $correctAnswers out of ${_questions.length} correct."),
            SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => JavaCourseSelectionPage()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text("Finish Course"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F), // Dark blue background
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar (Final - 100%)
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
                  Container(
                    height: 8,
                    width: MediaQuery.of(context).size.width, // Full progress
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Icon(Icons.star, color: Colors.yellow, size: 20),
                  ),
                ],
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Final Quiz",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Directions: Write True if the statement is correct, otherwise write False.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Questions Section
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final questionData = _questions[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionData["question"],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      ...questionData["options"].map<Widget>((option) {
                        bool isSelected = _selectedAnswers[index] == option;
                        bool isCorrect = option == questionData["answer"];
                        bool isWrongSelected = isSelected && !isCorrect;

                        Color answerColor = Colors.white24;
                        if (_selectedAnswers.containsKey(index)) {
                          if (isCorrect) {
                            answerColor = Colors.green; // Correct answer
                          } else if (isWrongSelected) {
                            answerColor = Colors.red; // Incorrect answer
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            if (_selectedAnswers.containsKey(index)) return;

                            setState(() {
                              _selectedAnswers[index] = option;
                              _answerCorrectness[index] = isCorrect;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: answerColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? (isCorrect ? Icons.check_circle : Icons.cancel)
                                      : Icons.circle_outlined,
                                  color: isSelected
                                      ? (isCorrect ? Colors.white : Colors.white)
                                      : Colors.white70,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  option,
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      if (_selectedAnswers.containsKey(index) && !_answerCorrectness[index]!)
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            "Correct answer: ${questionData["answer"]}",
                            style: TextStyle(fontSize: 16, color: Colors.greenAccent),
                          ),
                        ),

                      Divider(color: Colors.white24),
                    ],
                  );
                },
              ),
            ),

            // Submit Button
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _selectedAnswers.length == _questions.length ? _submitQuiz : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _selectedAnswers.length == _questions.length ? Colors.orange : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Submit Final Quiz",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
