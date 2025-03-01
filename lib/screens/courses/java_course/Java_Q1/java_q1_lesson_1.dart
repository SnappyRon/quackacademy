import 'package:flutter/material.dart';
import 'java_q1_lesson_2.dart';

class JavaQ1Lesson1Page extends StatelessWidget {
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
                    width: MediaQuery.of(context).size.width * 0.2, // 20% progress
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.2 - 16,
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
                    "BRIEF INTRODUCTION",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Intelligence is one of the key characteristics that differentiates humans from other living beings. Problem-solving is a crucial skill, and in programming, algorithms define the steps needed to solve problems systematically.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "WHAT IS AN ALGORITHM?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "An algorithm is a step-by-step procedure to solve problems. Examples include installing software, assembling appliances, or even following a recipe. In programming, an algorithm is expressed in a programming language or in pseudocode.",
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JavaQ1Lesson2Page()));
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
