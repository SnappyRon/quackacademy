import 'package:flutter/material.dart';

class CSSCoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      appBar: AppBar(
        title: Text("CSS Essentials"),
        backgroundColor: Color(0xFF1A3A5F),
      ),
      body: Center(
        child: Text(
          "Welcome to CSS Essentials!",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
