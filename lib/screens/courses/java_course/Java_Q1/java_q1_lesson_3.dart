import 'package:flutter/material.dart';
import 'java_q1_lesson_4.dart';

class JavaQ1Lesson3Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _progressBar(context, 0.6), // 60% progress

            // Lesson Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  _title("PROGRAMMING ALGORITHM"),
                  _text(
                      "A programming algorithm is a well-defined, step-by-step procedure used to solve a problem. It follows a logical sequence and ensures the correct output."),
                  SizedBox(height: 10),
                  _title("EXAMPLE: Validating an Email"),
                  _codeSnippet(
                    "Step 1: Start\n"
                    "Step 2: Create a variable for the email\n"
                    "Step 3: Clear old values\n"
                    "Step 4: Ask user for an email\n"
                    "Step 5: Store the input\n"
                    "Step 6: Validate email format\n"
                    "Step 7: If invalid, return to Step 4\n"
                    "Step 8: End",
                  ),
                ],
              ),
            ),

            _nextButton(context, JavaQ1Lesson4Page()),
          ],
        ),
      ),
    );
  }

  // Progress Bar
  Widget _progressBar(BuildContext context, double progress) {
    return Padding(
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
            width: MediaQuery.of(context).size.width * progress,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * progress - 16,
            child: Icon(Icons.star, color: Colors.yellow, size: 20),
          ),
        ],
      ),
    );
  }

  // Title Widget
  Widget _title(String text, {Color color = Colors.white}) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }

  // Text Widget
  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white70),
    );
  }

  // Code Snippet Box
  Widget _codeSnippet(String code) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        code,
        style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
      ),
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
            "Next Lesson",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
