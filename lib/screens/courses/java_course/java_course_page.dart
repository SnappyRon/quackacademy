import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q3/java_pretest_page.dart';
import 'Java_Q1/java_q1_lesson_1.dart'; // First lesson of Java_Q1
import 'Java_Q3/java_lesson_1.dart';   // First lesson of Java_Q3

class JavaCourseSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Same color scheme
      backgroundColor: Color(0xFF1E3A5F),
      appBar: AppBar(
        title: Text("Java Course"),
        backgroundColor: Color(0xFF1E3A5F),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Select a Java Quarter:",
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Java_Q1
          _javaQuarterCard(
            context,
            title: "Java Quarter 1",
            description: "Foundations of Java",
            onTap: () {
              // Navigate to Java Q1 Lesson 1
              Navigator.push(context, MaterialPageRoute(builder: (context) => JavaQ1Lesson1Page()));
            },
          ),

          // Java_Q3
          _javaQuarterCard(
            context,
            title: "Java Quarter 3",
            description: "Advanced Java topics",
            onTap: () {
              // Navigate to Java Q3 Lesson 1
              Navigator.push(context, MaterialPageRoute(builder: (context) => JavaPreTestPage()));
            },
          ),
        ],
      ),
    );
  }

  /// A reusable widget to display Java Q1 / Q3 in a card-like style
  Widget _javaQuarterCard(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white12, // Slightly transparent card
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white38),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 5),
            Text(description, style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
