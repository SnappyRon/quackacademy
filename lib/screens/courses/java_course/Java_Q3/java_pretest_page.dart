import 'package:flutter/material.dart';
import 'java_lesson_1.dart';

class JavaPreTestPage extends StatefulWidget {
  @override
  _JavaPreTestPageState createState() => _JavaPreTestPageState();
}

class _JavaPreTestPageState extends State<JavaPreTestPage> {
  Map<int, String?> _selectedAnswers = {};
  Map<int, bool?> _answerCorrectness = {};
  double _progress = 0.25;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "1. It is a set of accessibility in Java?",
      "options": ["Public", "Default", "Private", "Protected"],
      "answer": "Public"
    },
    {
      "question": "2. Which declaration is within a Java package?",
      "options": ["Public", "Default", "Private", "Protected"],
      "answer": "Default"
    },
    {
      "question": "3. The Java declaration found within the class only?",
      "options": ["Public", "Default", "Private", "Protected"],
      "answer": "Private"
    },
  ];

  void _submitAnswers() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => JavaLesson1Page()));
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
                            color: Colors.white),
                      ),
                      ...questionData["options"].map<Widget>((option) {
                        bool isSelected = _selectedAnswers[index] == option;
                        bool isCorrect = option == questionData["answer"];
                        bool isWrongSelected =
                            isSelected && !isCorrect; // If user picked wrong

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
                              _progress = (_selectedAnswers.length /
                                  _questions.length);
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
                                  color: isSelected
                                      ? (isCorrect
                                          ? Colors.white
                                          : Colors.white)
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

                      // Ensure the correct answer is always shown in green if wrong answer was picked
                      if (_selectedAnswers.containsKey(index) &&
                          !_answerCorrectness[index]!)
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

            // Continue Button
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _selectedAnswers.length == _questions.length ? _submitAnswers : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _selectedAnswers.length == _questions.length
                        ? Colors.orange
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Continue",
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
