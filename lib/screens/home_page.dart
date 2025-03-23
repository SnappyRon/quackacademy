import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import your Java course page here:
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';
import 'package:quackacademy/screens/join_page.dart';
import 'package:quackacademy/screens/create_session_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider that listens to the current user's Firestore document
final userDataProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data() ?? {});
  } else {
    return Stream.value({});
  }
});

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);
    return userDataAsync.when(
      data: (data) {
        final String role = data['role'] ?? "";
        final int completedLessons = data['completedLessons'] ?? 0;
        return Scaffold(
          backgroundColor: const Color(0xFF1A3A5F),
          body: HomeContent(
            role: role,
            completedLessons: completedLessons,
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: const Color(0xFF1A3A5F),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: const Color(0xFF1A3A5F),
        body: Center(child: Text("Error loading data")),
      ),
    );
  }
}

/// A separate widget that shows the main home UI, with the user role
/// and completedLessons passed in.
class HomeContent extends StatelessWidget {
  final String role;
  final int completedLessons;

  const HomeContent({
    Key? key,
    required this.role,
    required this.completedLessons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildProgressSection(context),
              const SizedBox(height: 20),
              _buildQuestSection(context),
              const SizedBox(height: 20),
              _buildCoursesSection(context),
              const SizedBox(height: 20),
              _buildAchievementsSection(),
              const SizedBox(height: 20),
              _buildSessionButtons(context),
              const SizedBox(height: 30),
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
          children: const [
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
        const Icon(Icons.notifications, color: Colors.white, size: 28),
      ],
    );
  }

  /// Dynamic Learning Progress Section
  Widget _buildProgressSection(BuildContext context) {
    const int totalLessons = 3;
    double progressRatio = (completedLessons / totalLessons).clamp(0.0, 1.0);
    final int progressPercent = (progressRatio * 100).round();
    final Color barColor = (progressPercent >= 100) ? Colors.green : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Learning Progress",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final double maxBarWidth = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    height: 8,
                    width: maxBarWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 8,
                    width: maxBarWidth * progressRatio,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$progressPercent%",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  /// Current Quest Section
  Widget _buildQuestSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Current Quest",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Foundations of Java",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
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
                onPressed: () {
                  // Check if the current context is still mounted before navigating.
                  if (!(context as Element).mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JavaCourseSelectionPage(),
                    ),
                  );
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Text(
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
  Widget _buildCoursesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Courses",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 16),
                _buildCourseIcon(context, 'assets/images/java.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Clickable Java icon that navigates to JavaCourseSelectionPage
  Widget _buildCourseIcon(BuildContext context, String assetPath) {
    return GestureDetector(
      onTap: () {
        if (!(context as Element).mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JavaCourseSelectionPage(),
          ),
        );
      },
      child: Image.asset(
        assetPath,
        width: 50,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, color: Colors.red, size: 50),
      ),
    );
  }

  /// Achievements Section
  Widget _buildAchievementsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Achievements",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAchievementCard("Top Novice", Colors.brown[300]!),
              _buildAchievementCard("Quiz Star", Colors.blueGrey[300]!),
              _buildAchievementCard("Perfect Quack", Colors.yellow[400]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Session Buttons (Create/Join)
  Widget _buildSessionButtons(BuildContext context) {
    final isTeacher = (role == "teacher");

    return Row(
      children: [
        if (isTeacher)
          Expanded(
            child: _buildSessionCard(
              "Create session here",
              "Create Now",
              Colors.green,
              context,
            ),
          ),
        if (isTeacher) const SizedBox(width: 10),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (!(context as Element).mounted) return;
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
