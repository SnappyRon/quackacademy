import 'package:flutter/material.dart';
import 'courses/html_course_page.dart';
import 'courses/css_course_page.dart';

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  // Manage course lock status
  Map<String, bool> courseLockStatus = {
    "HTML Basics": false, // ✅ Unlocked by default
    "CSS Essentials": true,
    "JavaScript": true,
    "Python": true,
    "C++": true,
    "Java": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: courseLockStatus.entries.map((entry) {
                    return _buildCourseCard(
                      context,
                      entry.key,
                      _getCourseSubtitle(entry.key),
                      _getCourseImage(entry.key),
                      entry.value,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Courses", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
            Text("Select a course to start learning!", style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
        Icon(Icons.school, color: Colors.orange, size: 28),
      ],
    );
  }

  /// ✅ Course Card with Image and Lock Handling
  Widget _buildCourseCard(BuildContext context, String title, String subtitle, String imagePath, bool isLocked) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, color: Colors.red, size: 40),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: isLocked
            ? Image.asset(
                'assets/images/Lock.png',
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.lock, color: Colors.red, size: 30),
              )
            : null,
        onTap: () {
          if (isLocked) {
            _showLockedDialog(context, title);
          } else {
            _navigateToCoursePage(context, title);
          }
        },
      ),
    );
  }

  /// ✅ Navigate to Course Page
  void _navigateToCoursePage(BuildContext context, String courseName) {
    if (courseName == "HTML Basics") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HTMLCoursePage(unlockNextCourse: _unlockNextCourse),
        ),
      );
    } else if (courseName == "CSS Essentials") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CSSCoursePage(),
        ),
      );
    }
  }

  /// ✅ Unlock Next Course
  void _unlockNextCourse(String courseName) {
    setState(() {
      if (courseLockStatus.containsKey(courseName)) {
        courseLockStatus[courseName] = false;
      }
    });
  }

  /// ✅ Show Locked Dialog
  void _showLockedDialog(BuildContext context, String courseName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Locked Course"),
        content: Text("$courseName is currently locked. Complete previous courses to unlock."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  /// ✅ Course Subtitles
  String _getCourseSubtitle(String courseName) {
    switch (courseName) {
      case "HTML Basics":
        return "Learn HTML from scratch";
      case "CSS Essentials":
        return "Master styling with CSS";
      case "JavaScript":
        return "Interactive web elements";
      case "Python":
        return "Intro to Python programming";
      case "C++":
        return "Deep dive into C++";
      case "Java":
        return "Java fundamentals";
      default:
        return "";
    }
  }

  /// ✅ Course Images
  String _getCourseImage(String courseName) {
    switch (courseName) {
      case "HTML Basics":
        return 'assets/images/html.png';
      case "CSS Essentials":
        return 'assets/images/css.png';
      case "JavaScript":
        return 'assets/images/js.png';
      case "Python":
        return 'assets/images/python.png';
      case "C++":
        return 'assets/images/Cplus.png';
      case "Java":
        return 'assets/images/java.png';
      default:
        return 'assets/images/placeholder.png';
    }
  }
}
