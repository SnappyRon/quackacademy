import 'package:flutter/material.dart';
import 'java_lesson_2.dart';

class JavaLesson1Page extends StatelessWidget {
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
                    "INSTANCEOF OPERATOR IN JAVA",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "The instanceof operator is used to test whether the value of an object is a specified type.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  _codeSnippet(
                    "class Main {\n"
                    "   public static void main(String[] args) {\n"
                    "      String name = \"Programmers\";\n"
                    "      boolean result = name instanceof String;\n"
                    "      System.out.println(\"Result: \" + result);\n"
                    "   }\n"
                    "}",
                  ),
                ],
              ),
            ),

            // Next Lesson Button (Styled like Pre-Test)
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JavaLesson2Page()));
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

  Widget _codeSnippet(String code) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
      child: Text(code, style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace')),
    );
  }
}
