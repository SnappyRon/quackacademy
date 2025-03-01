import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q1/java_q1_final_quiz.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q1/java_q1_pretest_page.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q3/java_final_quiz.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q3/java_pretest_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quackacademy/screens/learn_page.dart';

class JavaCourseSelectionPage extends StatefulWidget {
  @override
  _JavaCourseSelectionPageState createState() => _JavaCourseSelectionPageState();
}

class _JavaCourseSelectionPageState extends State<JavaCourseSelectionPage> {
  bool _isJavaQ1Completed = false;
  bool _isJavaQ3Completed = false;

  @override
  void initState() {
    super.initState();
    _loadLessonCompletion();
  }

  Future<void> _loadLessonCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isJavaQ1Completed = prefs.getBool("java_q1_completed") ?? false;
      _isJavaQ3Completed = prefs.getBool("java_q3_completed") ?? false;
    });
  }

  // -- THESE MARK METHODS are not strictly needed here anymore,
  //    since we do the marking in each quiz file. We'll leave them out
  //    to avoid confusion. The final quizzes handle marking internally.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Back Button
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    // Pop back to the LearnPage (restoring bottom nav)
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Back",
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Text(
              "Select a Java Quarter:",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Java Q1
            _quarterCard(
              title: "Java Quarter 1",
              description: "Foundations of Java",
              iconPath: "assets/java_logo.png",
              isCompleted: _isJavaQ1Completed,
              onTap: () async {
                // Navigate to Q1 Final Quiz
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JavaQ1PretestPage()),
                );
                // After returning, refresh completion status
                _loadLessonCompletion();
              },
            ),

            // Java Q3
            _quarterCard(
              title: "Java Quarter 3",
              description: "Advanced Java topics",
              iconPath: "assets/java_logo.png",
              isCompleted: _isJavaQ3Completed,
              onTap: () async {
                // Navigate to Q3 Final Quiz
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JavaPreTestPage()),
                );
                // After returning, refresh completion status
                _loadLessonCompletion();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Card for each quarter, with "Completed" indicator if isCompleted == true
  Widget _quarterCard({
    required String title,
    required String description,
    required String iconPath,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white38),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(description, style: TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ],
            ),
            if (isCompleted)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Completed",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
