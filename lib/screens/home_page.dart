import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quackacademy/main.dart';

// Import your Java course page and other pages.
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';
import 'package:quackacademy/screens/join_page.dart';
import 'package:quackacademy/screens/create_session_page.dart';
import 'package:quackacademy/widgets/current_quest_widget.dart';

/// Riverpod provider that listens to the current user's Firestore document.
  final userDataProvider = StreamProvider<Map<String, dynamic>>((ref) {
    final authState = ref.watch(authStateChangesProvider).value;
    final userId = authState?.uid;
    
    if (userId == null) return Stream.value({});

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .handleError((error) => print("userDataProvider error: $error"))
        .map((doc) => doc.data() ?? {});
  });

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);
    return userDataAsync.when(
      data: (data) {
        print("HomePage: user data: $data");
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
      loading: () {
        print("HomePage: Loading user data...");
        return Scaffold(
          backgroundColor: const Color(0xFF1A3A5F),
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        print("HomePage error: $error");
        return Scaffold(
          backgroundColor: const Color(0xFF1A3A5F),
          body: Center(child: Text("Error loading data: $error")),
        );
      },
    );
  }
}

/// A separate widget that shows the main home UI.
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

              // Replaced your old quest section with the new reusable widget:
              const CurrentQuestWidget(),

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

  /// Header Section.
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
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  "Quacker! ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text("🦆", style: TextStyle(fontSize: 22)),
              ],
            ),
          ],
        ),
        // const Icon(Icons.notifications, color: Colors.white, size: 28),
      ],
    );
  }

  /// Dynamic Learning Progress Section.
  Widget _buildProgressSection(BuildContext context) {
    const int totalLessons = 3;
    double progressRatio = (completedLessons / totalLessons).clamp(0.0, 1.0);
    final int progressPercent = (progressRatio * 100).round();
    final Color barColor = (progressPercent >= 100) ? const Color(0xFF476F95) : const Color(0xFF324C6E);

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
                    duration: const Duration(milliseconds: 300),
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

  /// Courses Section (unchanged).
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

  /// Clickable Java icon that navigates to JavaCourseSelectionPage.
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

  /// Achievements Section.
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
        children: const [
          Text(
            "Achievements",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Session Buttons (unchanged).
  Widget _buildSessionButtons(BuildContext context) {
    final isTeacher = (role == "teacher");

    return Row(
      children: [
        if (isTeacher)
          Expanded(
            child: _buildSessionCard(
              "Create session here",
              "Create Now",
              const Color(0xFF476F95),
              context,
            ),
          ),
        if (isTeacher) const SizedBox(width: 10),
        Expanded(
          child: _buildSessionCard(
            "Join session here",
            "Join here >",
            const Color(0xFF476F95),
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
