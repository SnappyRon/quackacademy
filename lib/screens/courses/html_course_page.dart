import 'package:flutter/material.dart';

class HTMLCoursePage extends StatelessWidget {
  final Function(String) unlockNextCourse;

  HTMLCoursePage({required this.unlockNextCourse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      appBar: AppBar(
        title: Text("HTML Basics"),
        backgroundColor: Color(0xFF1A3A5F),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            unlockNextCourse("CSS Essentials"); // 🔓 Unlock CSS
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("CSS Essentials has been unlocked!")),
            );
            Navigator.pop(context);
          },
          child: Text("Complete HTML & Unlock CSS"),
        ),
      ),
    );
  }
}
