import 'package:flutter/material.dart';
import 'java_q1_lesson_5.dart';

class JavaQ1Lesson4Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _progressBar(context, 0.8), // 80% progress

            // Lesson Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  _title("HOW TO WRITE AN ALGORITHM"),
                  _text(
                      "Writing an algorithm requires understanding the problem, breaking it into steps, and structuring it properly."),
                  SizedBox(height: 10),
                  _title("EXAMPLE: Converting Feet to Centimeters"),
                  _codeSnippet(
                    "Step 1: Input Length in feet\n"
                    "Step 2: Convert to cm (L * 30)\n"
                    "Step 3: Output result",
                  ),
                ],
              ),
            ),

            _nextButton(context, JavaQ1Lesson5Page()),
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
