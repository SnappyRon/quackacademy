import 'package:flutter/material.dart';
import 'java_q1_lesson_3.dart';

class JavaQ1Lesson2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
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
                    width: MediaQuery.of(context).size.width * 0.4, // 40% progress
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.4 - 16,
                    child: Icon(Icons.star, color: Colors.yellow, size: 20),
                  ),
                ],
              ),
            ),

            // Lesson Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Text(
                    "STEPS IN WRITING AN ALGORITHM",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "1. Determine the outcome of your code.",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "   - What is the specific problem you want to solve?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "2. Decide on a starting point.",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "   - What data/inputs are available?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "3. Find the ending point of the algorithm.",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "   - What changes from start to end?",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Next Lesson Button
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JavaQ1Lesson3Page()));
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
            ),
          ],
        ),
      ),
    );
  }
}
