import 'package:flutter/material.dart';

class JavaQ1FinalQuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _title("FINAL QUIZ"),

            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  _question(
                    "1. Which of the following is an example of an algorithm?",
                    [
                      "A. Recipe instructions",
                      "B. Random guessing",
                      "C. Making assumptions",
                      "D. Ignoring steps"
                    ],
                  ),
                  SizedBox(height: 20), // Add spacing
                  _question(
                    "2. What is the primary purpose of an algorithm?",
                    [
                      "A. To provide step-by-step instructions",
                      "B. To confuse programmers",
                      "C. To skip problem-solving",
                      "D. To create bugs"
                    ],
                  ),
                  SizedBox(height: 20), // Add spacing
                  _question(
                    "3. What is the best approach when writing an algorithm?",
                    [
                      "A. Break the problem into smaller steps",
                      "B. Start coding immediately",
                      "C. Ignore the problem statement",
                      "D. Just guess the solution"
                    ],
                  ),
                  SizedBox(height: 20), // Add spacing
                  _question(
                    "4. What should an algorithm always have?",
                    [
                      "A. A clear start and end",
                      "B. Infinite steps",
                      "C. Randomized execution",
                      "D. Only one possible solution"
                    ],
                  ),
                ],
              ),
            ),

            _finishButton(context),
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

  // Question Widget
  Widget _question(String question, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10),
        Column(
          children: options.map((option) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  option,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Finish Button
  Widget _finishButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Return to previous screen
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            "Finish Quiz",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
