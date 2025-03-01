import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';

class CourseSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F), // Dark blue background
      appBar: AppBar(
        title: Text("Courses"),
        backgroundColor: Color(0xFF1E3A5F),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Select a course to start learning!",
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 16),

          // Java
          _courseCard(
            context,
            iconPath: "assets/java_logo.png",
            title: "Java",
            description: "Java fundamentals",
            locked: false,
            onTap: () {
              // Navigate to Java Course Selection Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JavaCourseSelectionPage()),
              );
            },
          ),

          // Python
          _courseCard(
            context,
            iconPath: "assets/python_logo.png",
            title: "Python",
            description: "Learn Python basics",
            locked: false,
            onTap: () {
              // TODO: Navigate to Python Course if available
            },
          ),

          // The rest of the courses...

        ],
      ),
    );
  }

  /// A reusable widget to display each course in a card-like format
  Widget _courseCard(
    BuildContext context, {
    required String iconPath,
    required String title,
    required String description,
    required bool locked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: locked ? null : onTap, // If locked, disable tap
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // White card background
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Course Icon
            Image.asset(
              iconPath,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                // Graceful fallback if asset is missing
                return Icon(Icons.error, color: Colors.red, size: 40);
              },
            ),
            SizedBox(width: 16),

            // Course Title + Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A5F),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Lock / Unlock Icon
            Icon(
              locked ? Icons.lock : Icons.lock_open,
              color: locked ? Colors.grey : Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
