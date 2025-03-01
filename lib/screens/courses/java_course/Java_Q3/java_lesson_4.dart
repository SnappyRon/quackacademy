import 'package:flutter/material.dart';
import 'java_lesson_5.dart';

class JavaLesson4Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar (80%)
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.8 - 16,
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
                    "BITWISE & ASSIGNMENT OPERATORS",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Bitwise operators perform operations on bits: &, |, ^, <<, >>.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  _codeSnippet(
                    "public class Main {\n"
                    "   public static void main(String[] args) {\n"
                    "      int a = 5, b = 3;\n"
                    "      System.out.println(a & b); // 1\n"
                    "   }\n"
                    "}",
                  ),
                  SizedBox(height: 20),
                  Text(
                    "ASSIGNMENT OPERATORS",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Assignment operators assign values: =, +=, -=, *=, /=.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  _codeSnippet(
                    "public class Main {\n"
                    "   public static void main(String[] args) {\n"
                    "      int a = 10;\n"
                    "      a += 5; // a = a + 5\n"
                    "      System.out.println(a); // 15\n"
                    "   }\n"
                    "}",
                  ),
                ],
              ),
            ),

            // Next Lesson Button
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JavaLesson5Page()));
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
