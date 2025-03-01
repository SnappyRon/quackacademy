import 'package:flutter/material.dart';
import 'java_q1_pretest_page.dart';

class JavaQ1Lesson5Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _progressBar(context, 1.0), // 100% progress

            // Lesson Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  _title("REVIEW"),
                  _text(
                      "Let's review everything we've learned about algorithms, their structure, and their real-world applications."),
                ],
              ),
            ),

            _nextButton(context, JavaQ1PretestPage()),
          ],
        ),
      ),
    );
  }

  // Progress Bar Widget
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
  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  // Text Widget
  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white70),
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
