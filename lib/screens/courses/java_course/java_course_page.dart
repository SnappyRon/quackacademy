import 'package:flutter/material.dart';
import 'package:quackacademy/main_navigator.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q1/java_q1_pretest_page.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q2/java_all_lessons_page.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q3/java_pretest_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JavaCourseSelectionPage extends StatefulWidget {
  @override
  _JavaCourseSelectionPageState createState() =>
      _JavaCourseSelectionPageState();
}

class _JavaCourseSelectionPageState extends State<JavaCourseSelectionPage> {
  bool _isJavaQ1Completed = false;
  bool _isJavaQ2Completed = false;
  bool _isJavaQ3Completed = false;

  // Set _currentIndex to 1 for the "Learn" tab
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadLessonCompletion();
  }

  Future<void> _loadLessonCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isJavaQ1Completed = prefs.getBool("java_q1_completed") ?? false;
      _isJavaQ2Completed = prefs.getBool("java_q2_completed") ?? false;
      _isJavaQ3Completed = prefs.getBool("java_q3_completed") ?? false;
    });
  }

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
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Select a Java Lesson:",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Java Quarter Cards
            _quarterCard(
              title: "Java Quarter 1",
              description: "Foundations of Java",
              iconPath: "assets/images/javaicon1.png",
              isCompleted: _isJavaQ1Completed,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JavaQ1PretestPage()),
                );
                if (!mounted) return;
                _loadLessonCompletion();
              },
            ),
            _quarterCard(
              title: "Java Quarter 2",
              description: "Apply Basics of Java Language",
              iconPath: "assets/images/javaicon2.png",
              isCompleted: _isJavaQ2Completed,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JavaPreTestPage()),
                );
                if (!mounted) return;
                _loadLessonCompletion();
              },
            ),
            _quarterCard(
              title: "Java Quarter 3",
              description: "Advanced Java topics",
              iconPath: "assets/images/javaicon2.png",
              isCompleted: _isJavaQ3Completed,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JavaPreTestPage()),
                );
                if (!mounted) return;
                _loadLessonCompletion();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF1A3A5F),
          unselectedItemColor: Colors.black54,
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == _currentIndex) return;
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainNavigator(gameCode: 'defaultGameCode')),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainNavigator(gameCode: 'defaultGameCode')),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainNavigator(gameCode: 'defaultGameCode')),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainNavigator(gameCode: 'defaultGameCode')),
                );
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Home.png',
                width: 24,
                height: 24,
                color: _currentIndex == 0
                    ? Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Courses.png',
                width: 24,
                height: 24,
                color: _currentIndex == 1
                    ? Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Learn",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Leaderboard.png',
                width: 24,
                height: 24,
                color: _currentIndex == 2
                    ? Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Profile.png',
                width: 24,
                height: 24,
                color: _currentIndex == 3
                    ? Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

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
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(description,
                        style: TextStyle(
                            fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ],
            ),
            if (isCompleted)
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Completed",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
