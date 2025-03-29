import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';
import 'package:quackacademy/services/exp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JavaQ1FinalQuizPage extends StatefulWidget {
  @override
  _JavaQ1FinalQuizPageState createState() => _JavaQ1FinalQuizPageState();
}

class _JavaQ1FinalQuizPageState extends State<JavaQ1FinalQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedAnswerIndex = -1;
  bool _answered = false;

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
      "feedback": [
        "Correct! Identifying the problem is the first step to solving it.",
        "Incorrect. Learning facts helps, but it's not the starting point.",
        "Incorrect. Formulas are useful later, not at the beginning.",
        "Incorrect. Understanding changes is more about outcomes than problems."
      ],
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
      "feedback": [
        "Incorrect. Knowing input data is part of defining a start.",
        "Incorrect. Locating data is essential to process steps.",
        "Incorrect. Facts gathered help with clarity.",
        "Correct! Formulas aren’t directly needed to find a starting point."
      ],
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
      "feedback": [
        "Incorrect. Facts help define the outcome.",
        "Incorrect. Identifying changes is key to the end point.",
        "Incorrect. Additions/removals matter in defining the end.",
        "Correct! Data relationships help with logic, not defining the endpoint."
      ],
    },
    {
      "question": "4. To use a real-world example, let’s say your goal is to have lasagna for dinner...",
      "options": [
        "A. Determine how will you accomplish each step.",
        "B. List the steps from start to finish.",
        "C. Find the ending point of the algorithm.",
        "D. Determine the outcome of your code."
      ],
      "correct": 1,
      "feedback": [
        "Incorrect. That comes after listing the steps.",
        "Correct! Writing the steps defines the algorithm.",
        "Incorrect. You already know the end goal.",
        "Incorrect. The outcome is already defined as dinner by 7."
      ],
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
      "feedback": [
        "Correct! Reviewing ensures it's complete and efficient.",
        "Incorrect. That's done earlier in the process.",
        "Incorrect. That’s also established before writing.",
        "Incorrect. You’ve already done this during creation."
      ],
    },
    {
      "question": "6. The aim of pseudocode is to make programming easier by using symbols",
      "options": ["A. Yes", "B. No", "C. Maybe", "D. All of the above"],
      "correct": 2,
      "feedback": [
        "Incorrect. This is too definitive.",
        "Incorrect. Pseudocode *can* make programming easier.",
        "Correct! The statement is unclear—so 'Maybe' is most accurate.",
        "Incorrect. This option is too broad."
      ],
    },
    {
      "question": "7. ___ is a way of expressing an algorithm without conforming to specific syntactic rules.",
      "options": ["A. Pseudocode", "B. Data Type", "C. Algorithm", "D. Flowchart"],
      "correct": 0,
      "feedback": [
        "Correct! Pseudocode uses natural language to describe logic.",
        "Incorrect. Data types define data, not logic flow.",
        "Incorrect. Algorithms are the logic, not the representation.",
        "Incorrect. Flowcharts are visual, not text-based."
      ],
    },
    {
      "question": "8. It is one of the key characteristics that differentiate humans from other living creatures on earth?",
      "options": ["A. Kindness", "B. Character", "C. Intelligence", "D. Beauty"],
      "correct": 2,
      "feedback": [
        "Incorrect. Not unique to humans alone.",
        "Incorrect. Many species show character traits.",
        "Correct! Intelligence uniquely defines human capabilities.",
        "Incorrect. Beauty is subjective and not exclusive."
      ],
    },
    {
      "question": "9. It indicates any type of internal operation inside the processor or memory.",
      "options": ["A. Connector", "B. Terminal", "C. Input/Output", "D. Process"],
      "correct": 1,
      "feedback": [
        "Incorrect. Connectors link elements, not processes.",
        "Correct! Terminal symbols represent internal operations.",
        "Incorrect. I/O is about external interactions.",
        "Incorrect. Process symbols show actions, but not specific to internal."
      ],
    },
    {
      "question": "10. It is a data type that holds numbers with a decimal point.",
      "options": ["A. Boolean", "B. Integer", "C. String", "D. Float"],
      "correct": 3,
      "feedback": [
        "Incorrect. Boolean holds true/false only.",
        "Incorrect. Integer holds whole numbers.",
        "Incorrect. Strings hold text.",
        "Correct! Float represents decimal numbers."
      ],
    },
  ];

  Future<bool> _markJavaQ1Completed() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final String userQ1Key = "java_q1_completed_${user.uid}";
    final String expAwardedKey = "java_q1_exp_awarded_${user.uid}";

    bool alreadyCompleted = prefs.getBool(userQ1Key) ?? false;
    bool expAlreadyAwarded = prefs.getBool(expAwardedKey) ?? false;

    if (!alreadyCompleted) {
      await prefs.setBool(userQ1Key, true);
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
    bool newlyAwardedExp = await _markJavaQ1Completed();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E3A5F),
        title: const Text("Quiz Completed!", style: TextStyle(color: Colors.white)),
        content: Text(
          newlyAwardedExp
              ? "Congratulations! You've earned +50 EXP.\n\nYou scored $_score out of ${_questions.length}."
              : "You scored $_score out of ${_questions.length}.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text("Finish", style: TextStyle(color: Colors.greenAccent)),
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
      backgroundColor: const Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Score: $_score/${_questions.length}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _question(current["question"]),
                    const SizedBox(height: 10),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _question(String question) {
    return Text(
      question,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: optionColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white38),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
