import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackacademy/services/exp_service.dart';

class JavaFinalQuizPage extends StatefulWidget {
  @override
  _JavaFinalQuizPageState createState() => _JavaFinalQuizPageState();
}

class _JavaFinalQuizPageState extends State<JavaFinalQuizPage> {
  Map<int, String?> _selectedAnswers = {};
  Map<int, bool?> _answerCorrectness = {};

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "1. The Java declaration for String msg=\"Hello World!\";",
      "options": ["True", "False"],
      "answer": "True",
      "feedback": [
        "Correct! This is a valid declaration of a String in Java.",
        "Incorrect. This syntax is actually correct in Java."
      ],
    },
    {
      "question":
          "2. The Java declaration:\n\nint a=80; b=85; c=90; int grade; grade = (a+b+c)/3;\nSystem.out.println(\"The Final Grade:\"+grade);",
      "options": ["True", "False"],
      "answer": "True",
      "feedback": [
        "Correct! This code will compile and output the average.",
        "Incorrect. The code works and prints the final grade correctly."
      ],
    },
    {
      "question": "3. The Java language has no compiler.",
      "options": ["True", "False"],
      "answer": "False",
      "feedback": [
        "Incorrect. Java **does** have a compiler: `javac`.",
        "Correct! Java has a compiler to convert code into bytecode."
      ],
    },
    {
      "question": "4. The library import java.io.* : io means input output.",
      "options": ["True", "False"],
      "answer": "True",
      "feedback": [
        "Correct! `io` stands for Input/Output operations.",
        "Incorrect. `io` indeed refers to Input/Output in Java."
      ],
    },
    {
      "question":
          "5. The value a=73; b=75; g=(a+b)/2; If g >75; remarks =\"True\" else remarks =\"False\".",
      "options": ["True", "False"],
      "answer": "False",
      "feedback": [
        "Incorrect. The result of (73+75)/2 is 74, which is not greater than 75.",
        "Correct! The average is 74, so the condition fails and 'False' is correct."
      ],
    },
  ];

  Future<bool> _markJavaQ3Completed() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final String userQ3Key = "java_q3_completed_${user.uid}";
    final String expAwardedKey = "java_q3_exp_awarded_${user.uid}";

    bool alreadyCompleted = prefs.getBool(userQ3Key) ?? false;
    bool expAlreadyAwarded = prefs.getBool(expAwardedKey) ?? false;

    if (!alreadyCompleted) {
      await prefs.setBool(userQ3Key, true);
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

  Future<void> _submitQuiz() async {
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      final correct = _questions[i]["answer"];
      if (_selectedAnswers[i] == correct) {
        correctAnswers++;
      }
    }

    bool awardedExp = await _markJavaQ3Completed();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E3A5F),
        title: const Text("Quiz Completed!",
            style: TextStyle(color: Colors.white)),
        content: Text(
          awardedExp
              ? "Congratulations! You've earned +50 EXP.\n\nYou got $correctAnswers out of ${_questions.length} correct."
              : "You got $correctAnswers out of ${_questions.length} correct.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text("Finish Course",
                style: TextStyle(color: Colors.greenAccent)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
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
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    child: Icon(Icons.star, color: Colors.yellow, size: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Text("Final Quiz",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 8),
                  Text(
                      "Directions: Write True if the statement is correct, otherwise False.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final questionData = _questions[index];
                  final feedback = questionData["feedback"];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(questionData["question"],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      ...questionData["options"].map<Widget>((option) {
                        bool isSelected = _selectedAnswers[index] == option;
                        bool isCorrect = option == questionData["answer"];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAnswers[index] = option;
                              _answerCorrectness[index] = isCorrect;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.white24,
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
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(option,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      if (_selectedAnswers.containsKey(index))
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, bottom: 10),
                          child: Text(
                            feedback[_questions[index]["options"]
                                .indexOf(_selectedAnswers[index])],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.yellowAccent),
                          ),
                        ),
                      const Divider(color: Colors.white24),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity, // Make button fill width
                child: ElevatedButton(
                  onPressed: _selectedAnswers.length == _questions.length
                      ? _submitQuiz
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedAnswers.length == _questions.length
                            ? Color(0xFF476F95) // Active = your palette
                            : Colors.grey, // Inactive = gray
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    "Submit Final Quiz",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
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
