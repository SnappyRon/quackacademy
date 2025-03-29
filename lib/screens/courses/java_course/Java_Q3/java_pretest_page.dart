import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q3/java_all_lessons_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JavaPreTestPage3 extends StatefulWidget {
  @override
  _JavaPreTestPage3State createState() => _JavaPreTestPage3State();
}

class _JavaPreTestPage3State extends State<JavaPreTestPage3> {
  Map<int, String?> _selectedAnswers = {};
  Map<int, bool?> _answerCorrectness = {};
  double _progress = 0.25;

  /// Pre-test questions with EXP text removed
  final List<Map<String, dynamic>> _questions = [
    {
      "question": "1. It is a set of accessibility in Java?",
      "options": ["Public", "Default", "Private", "Protected"],
      "answer": "Public",
      "explanation": "Public means the member is visible everywhere."
    },
    {
      "question": "2. Which declaration is within a Java package?",
      "options": ["Public", "Default", "Private", "Protected"],
      "answer": "Default",
      "explanation": "Default has package-level visibility."
    },
    {
      "question": "3. The Java declaration found within the class only?",
      "options": ["Public", "Default", "Private", "Protected"],
      "answer": "Private",
      "explanation": "Private restricts access to the declaring class."
    },
  ];

  /// Updated submit function without EXP awarding
  Future<void> _submitAnswers() async {
    // Check SharedPreferences to see if the pre-test is already completed
    final prefs = await SharedPreferences.getInstance();
    final pretestDone = prefs.getBool('pretest_completed') ?? false;

    if (!pretestDone) {
      // Mark this test as completed in SharedPreferences
      await prefs.setBool('pretest_completed', true);
    }

    // Navigate to JavaAllLessonsPage3
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JavaAllLessonsPage3()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F), // Dark blue background
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
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
                    width: MediaQuery.of(context).size.width * _progress,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width * _progress - 16,
                    child: Icon(Icons.star, color: Colors.yellow, size: 20),
                  ),
                ],
              ),
            ),

            // Header Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Pre-Test Instructions",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Answer the following questions before proceeding.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Questions
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ...questionData["options"].map<Widget>((option) {
                        bool isSelected = _selectedAnswers[index] == option;
                        bool isCorrect = option == questionData["answer"];
                        bool isWrongSelected =
                            isSelected && !isCorrect; // If user picked wrong

                        Color answerColor = Colors.white24;
                        if (_selectedAnswers.containsKey(index)) {
                          if (isCorrect) {
                            answerColor = Colors.green;
                          } else if (isWrongSelected) {
                            answerColor = Colors.red;
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            if (_selectedAnswers.containsKey(index)) return;
                            setState(() {
                              _selectedAnswers[index] = option;
                              _answerCorrectness[index] = isCorrect;
                              _progress =
                                  (_selectedAnswers.length / _questions.length);
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
                                      ? (isCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel)
                                      : Icons.circle_outlined,
                                  color:
                                      isSelected ? Colors.white : Colors.white70,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  option,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      // If answered incorrectly, show correct answer + explanation
                      if (_selectedAnswers.containsKey(index) &&
                          _answerCorrectness[index] == false)
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            "Correct answer: ${questionData["answer"]}\nWhy? ${questionData["explanation"]}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.greenAccent),
                          ),
                        ),

                      // If answered correctly, also show explanation
                      if (_selectedAnswers.containsKey(index) &&
                          _answerCorrectness[index] == true)
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            "Great job!\n${questionData["explanation"]}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.lightBlueAccent),
                          ),
                        ),

                      Divider(color: Colors.white24),
                    ],
                  );
                },
              ),
            ),

            // Continue Button
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap:
                    _selectedAnswers.length == _questions.length ? _submitAnswers : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _selectedAnswers.length == _questions.length
                        ?  Color(0xFF476F95)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
