import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quackacademy/screens/join_page.dart';
import 'package:quackacademy/screens/create_session_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Store the user role
  String _role = "";

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  /// Fetch user role from Firestore
  Future<void> _fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc['role'] != null) {
        setState(() {
          _role = doc['role'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Just show the home content (no extra bottom nav here).
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: HomeContent(role: _role),
    );
  }
}

/// A separate widget that shows the main home UI, with the user role passed in.
class HomeContent extends StatelessWidget {
  final String role;
  const HomeContent({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildProgressSection(),
              SizedBox(height: 20),
              _buildQuestSection(),
              SizedBox(height: 20),
              _buildCoursesSection(),
              SizedBox(height: 20),
              _buildAchievementsSection(),
              SizedBox(height: 20),
              _buildSessionButtons(context),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// Header Section
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            Row(
              children: [
                Text(
                  "Quacker! ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text("🦆", style: TextStyle(fontSize: 22)),
              ],
            ),
          ],
        ),
        Icon(Icons.notifications, color: Colors.white, size: 28),
      ],
    );
  }

  /// Learning Progress Section
  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Learning Progress",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Example static bar
              Container(
                height: 8,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text("65%", style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  /// Current Quest Section
  Widget _buildQuestSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Quest",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Foundations of Java",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                "Deadline!",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Courses Section
  Widget _buildCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Courses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        // If you want a scrolling row:
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 16),
              _buildCourseIcon('assets/images/java.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseIcon(String assetPath) {
    return Image.asset(
      assetPath,
      width: 50,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.error, color: Colors.red, size: 50),
    );
  }

  /// Achievements Section
  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Achievements",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAchievementCard("Top Novice", Colors.brown[300]!),
            _buildAchievementCard("Quiz Star", Colors.blueGrey[300]!),
            _buildAchievementCard("Perfect Quack", Colors.yellow[400]!),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementCard(String title, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Session Buttons (Create/Join)
  Widget _buildSessionButtons(BuildContext context) {
    // We already have 'role' passed into this widget
    final isTeacher = (role == "teacher");

    return Row(
      children: [
        // Only show "Create session" if user role == "teacher"
        if (isTeacher)
          Expanded(
            child: _buildSessionCard(
              "Create session here",
              "Create Now",
              Colors.green,
              context,
            ),
          ),
        if (isTeacher) SizedBox(width: 10),
        // Always show "Join session"
        Expanded(
          child: _buildSessionCard(
            "Join session here",
            "Join here >",
            Colors.orange,
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(
    String title,
    String buttonText,
    Color color,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (buttonText.contains("Join")) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateSessionPage()),
                );
              }
            },
            child: Text(buttonText, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }
}
