import 'package:flutter/material.dart';
import 'java_q1_final_quiz.dart';

class JavaQ1PretestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _title("PRE-TEST"),

            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  _question(
                    "1. What is the first step in writing an algorithm?",
                    [
                      "A. Define the problem",
                      "B. Start coding immediately",
                      "C. Ignore the problem statement",
                      "D. Skip to testing"
                    ],
                  ),
                  SizedBox(height: 20), // Add spacing
                  _question(
                    "2. Why is defining the problem important?",
                    [
                      "A. It helps structure the solution",
                      "B. It speeds up coding",
                      "C. It makes debugging easier",
                      "D. It is not necessary"
                    ],
                  ),
                  SizedBox(height: 20), // Add spacing
                  _question(
                    "3. What does an algorithm consist of?",
                    [
                      "A. A series of steps",
                      "B. Random instructions",
                      "C. Only mathematical operations",
                      "D. Just a single action"
                    ],
                  ),
                ],
              ),
            ),

            _nextButton(context, JavaQ1FinalQuizPage()),
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

  // Next Button
  Widget _nextButton(BuildContext context, Widget nextPage) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            "Next: Final Quiz",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
