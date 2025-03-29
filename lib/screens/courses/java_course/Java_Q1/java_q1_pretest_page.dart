import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q1/java_all_lessons_page.dart';

class JavaQ1PretestPage extends StatefulWidget {
  @override
  _JavaQ1PretestPageState createState() => _JavaQ1PretestPageState();
}

class _JavaQ1PretestPageState extends State<JavaQ1PretestPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedAnswerIndex = -1; // Track selected answer
  bool _answered = false; // Track if the user has answered

  // Updated Pre-Test Questions with feedback for each answer option
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
        "Correct! Knowing the specific problem ensures the solution meets the intended goal.",
        "Incorrect. While facts may be gathered, the focus is on identifying the problem to solve.",
        "Incorrect. Formulas may help later, but the problem must be defined first.",
        "Incorrect. Determining changes is not the initial step in understanding the problem."
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
        "Incorrect. Knowing what data is available is key to starting the process.",
        "Incorrect. Locating the data is essential for understanding your starting point.",
        "Incorrect. Learning the facts from the process helps define the initial situation.",
        "Correct! Determining applicable formulas is not necessary for establishing the starting point."
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
        "Incorrect. Learning facts from the process helps define the outcome.",
        "Incorrect. Changes between the start and end are crucial for determining the result.",
        "Incorrect. Understanding what is added or removed is part of outlining the end point.",
        "Correct! While relationships between data values are important, they are not used to define the end point."
      ],
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
      "feedback": [
        "Incorrect. Determining how to accomplish each step comes after listing the steps.",
        "Correct! Listing the steps from start to finish lays out your algorithm.",
        "Incorrect. You already know the ending point.",
        "Incorrect. The outcome is already defined as having a cooked lasagna."
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
        "Correct! Reviewing the algorithm helps you evaluate and optimize the process.",
        "Incorrect. The steps have already been listed.",
        "Incorrect. The end point is already known.",
        "Incorrect. Determining the method is part of creating the algorithm, not evaluating it."
      ],
    },
  ];

  // Function to handle answer selection
  void _selectAnswer(int selectedIndex) {
    if (_answered) return; // Prevent multiple selections

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _answered = true;

      if (selectedIndex == _questions[_currentQuestionIndex]["correct"]) {
        _score++; // Increase score for correct answers
      }

      // Wait 1 second before moving to next question
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          if (_currentQuestionIndex < _questions.length - 1) {
            _currentQuestionIndex++; // Move to next question
            _selectedAnswerIndex = -1; // Reset selection
            _answered = false; // Allow new selection
          } else {
            _showResultsDialog(); // Quiz finished
          }
        });
      });
    });
  }

  // Show results at the end of the quiz
  void _showResultsDialog() {
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
            child: Text("Next: Lesson 1", style: TextStyle(color: Colors.greenAccent)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JavaAllLessonsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentQuestion = _questions[_currentQuestionIndex];
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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

            _title("PRE-TEST"),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _question(currentQuestion["question"]),
                    SizedBox(height: 10),
                    ...List.generate(
                      currentQuestion["options"].length,
                      (index) => _answerOption(
                        text: currentQuestion["options"][index],
                        index: index,
                      ),
                    ),
                    // Feedback widget: Show explanation if the user answered incorrectly.
                    if (_answered &&
                        _selectedAnswerIndex != currentQuestion["correct"])
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          currentQuestion["feedback"][_selectedAnswerIndex],
                          style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
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
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // Question Text Widget
  Widget _question(String question) {
    return Text(
      question,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  // Answer Option Widget (with color feedback)
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
