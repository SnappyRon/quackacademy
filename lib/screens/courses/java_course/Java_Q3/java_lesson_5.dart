import 'package:flutter/material.dart';
import 'java_final_quiz.dart';

class JavaLesson5Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar (100%)
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
                  Container(
                    height: 8,
                    width: MediaQuery.of(context).size.width, // Full progress
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    right: 0,
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
                    "LOGICAL OPERATORS",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Logical operators compare boolean values: &&, ||, !.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  _codeSnippet(
                    "public class Main {\n"
                    "   public static void main(String[] args) {\n"
                    "      boolean a = true, b = false;\n"
                    "      System.out.println(a && b); // false\n"
                    "      System.out.println(a || b); // true\n"
                    "   }\n"
                    "}",
                  ),
                ],
              ),
            ),

            // Take Final Quiz Button
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JavaFinalQuizPage()));
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
                    "Take Final Quiz",
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
