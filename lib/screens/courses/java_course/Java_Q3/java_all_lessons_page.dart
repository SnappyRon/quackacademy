import 'package:flutter/material.dart';
import 'java_final_quiz.dart'; // Adjust the path if necessary

class JavaAllLessonsPage1 extends StatefulWidget {
  @override
  _JavaAllLessonsPage1State createState() => _JavaAllLessonsPage1State();
}

class _JavaAllLessonsPage1State extends State<JavaAllLessonsPage1> {
  int _currentLessonIndex = 0;
  final int _totalLessons = 5;

  double get _progress => (_currentLessonIndex + 1) / _totalLessons;

  // Lesson contents for Lessons 1 - 5
  List<List<Widget>> get _lessonContents => [
        // Lesson 1: INSTANCEOF OPERATOR IN JAVA
        [
          Text(
            "INSTANCEOF OPERATOR IN JAVA",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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

        // Lesson 2: TYPES OF OPERATORS IN JAVA
        [
          Text(
            "TYPES OF OPERATORS IN JAVA",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "Java has various types of operators: Arithmetic, Relational, Bitwise, Assignment, Logical, etc.",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "public static void main(String[] args) {\n"
            "   int a = 10, b = 5;\n"
            "   System.out.println(a + b); // 15\n"
            "}",
          ),
        ],

        // Lesson 3: ARITHMETIC & RELATIONAL OPERATORS
        [
          Text(
            "ARITHMETIC & RELATIONAL OPERATORS",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "public class Main {\n"
            "   public static void main(String[] args) {\n"
            "      int a = 10, b = 5;\n"
            "      System.out.println(a > b); // true\n"
            "   }\n"
            "}",
          ),
        ],

        // Lesson 4: BITWISE & ASSIGNMENT OPERATORS
        [
          Text(
            "BITWISE & ASSIGNMENT OPERATORS",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "Bitwise operators perform operations on bits: &, |, ^, <<, >>.",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 10),
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
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "Assignment operators assign values: =, +=, -=, *=, /=.",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 10),
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

        // Lesson 5: LOGICAL OPERATORS
        [
          Text(
            "LOGICAL OPERATORS",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "Logical operators compare boolean values: &&, ||, !.",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 10),
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
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(context, _progress),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: _lessonContents[_currentLessonIndex],
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  // Progress Bar Widget
  Widget _buildProgressBar(BuildContext context, double progress) {
    return Padding(
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
            width: MediaQuery.of(context).size.width * progress,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * progress - 16,
            child: Icon(Icons.star, color: Colors.yellow, size: 20),
          ),
        ],
      ),
    );
  }

  // Code Snippet Widget
  static Widget _codeSnippet(String code) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        code,
        style: TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  // Bottom Button Widget
  Widget _buildBottomButton(BuildContext context) {
    bool isLastLesson = _currentLessonIndex == _totalLessons - 1;
    return Padding(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          if (!isLastLesson) {
            setState(() {
              _currentLessonIndex++;
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JavaFinalQuizPage()),
            );
          }
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
            isLastLesson ? "Take Final Quiz" : "Next Lesson",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
