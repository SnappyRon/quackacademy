import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quackacademy/main_navigator.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q1/java_q1_pretest_page.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q2/java_all_lessons_page.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q3/java_pretest_page.dart';
import 'package:quackacademy/main_navigator.dart'; // For currentTabIndexProvider
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quackacademy/services/exp_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JavaCourseSelectionPage extends ConsumerStatefulWidget {
  @override
  _JavaCourseSelectionPageState createState() =>
      _JavaCourseSelectionPageState();
}

class _JavaCourseSelectionPageState
    extends ConsumerState<JavaCourseSelectionPage> {
  // Tracks whether each Java Quarter is completed
  bool _isJavaQ1Completed = false;
  bool _isJavaQ2Completed = false;
  bool _isJavaQ3Completed = false;

  // We'll store the old states so we can detect new completions
  bool _previousJavaQ1Completed = false;
  bool _previousJavaQ2Completed = false;
  bool _previousJavaQ3Completed = false;

  // Current user UID
  String? _uid;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _uid = user?.uid;

    _loadLessonCompletion();

    // Set the bottom nav tab to "Learn" (index 1).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentTabIndexProvider.notifier).state = 1;
    });
  }

  /// Loads lesson completion from SharedPreferences (using user-scoped keys),
  /// compares old vs. new, then awards EXP if newly completed.
Future<void> _loadLessonCompletion() async {
  if (_uid == null) {
    setState(() {
      _isJavaQ1Completed = false;
      _isJavaQ2Completed = false;
      _isJavaQ3Completed = false;
    });
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  if (!mounted) return;

  final String q1Key = "java_q1_completed_$_uid";
  final String q2Key = "java_q2_completed_$_uid";
  final String q3Key = "java_q3_completed_$_uid";

  bool storedJavaQ1Completed = prefs.getBool(q1Key) ?? false;
  bool storedJavaQ2Completed = prefs.getBool(q2Key) ?? false;
  bool storedJavaQ3Completed = prefs.getBool(q3Key) ?? false;


  setState(() {
    _isJavaQ1Completed = storedJavaQ1Completed;
    _isJavaQ2Completed = storedJavaQ2Completed;
    _isJavaQ3Completed = storedJavaQ3Completed;
  });
}

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentTabIndexProvider);

    // “Lock” logic: user must complete previous quarter before accessing the next
    final bool isQ2Locked = !_isJavaQ1Completed; // Q1 must be done to unlock Q2
    final bool isQ3Locked = !_isJavaQ2Completed; // Q2 must be done to unlock Q3

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Back Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF476F95),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
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
            const Text(
              "Select a Java Lesson:",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Java Quarter 1
            _quarterCard(
              title: "Java Quarter 1",
              description: "Foundations of Java",
              iconPath: "assets/images/javaicon1.png",
              isCompleted: _isJavaQ1Completed,
              isLocked: false, // Q1 is always accessible
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JavaQ1PretestPage()),
                );
                if (!mounted) return;
                _loadLessonCompletion();
              },
            ),

            // Java Quarter 2
            _quarterCard(
              title: "Java Quarter 2",
              description: "Apply Basics of Java Language",
              iconPath: "assets/images/javaicon2.png",
              isCompleted: _isJavaQ2Completed,
              isLocked: isQ2Locked, // Q2 locked if Q1 not done
              onTap: () async {
                // If locked, show a warning and do nothing
                if (isQ2Locked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You need to finish Quarter 1 first!"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }
                // Otherwise proceed
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JavaAllLessonsPage2()),
                );
                if (!mounted) return;
                _loadLessonCompletion();
              },
            ),

            // Java Quarter 3
            _quarterCard(
              title: "Java Quarter 3",
              description: "Advanced Java topics",
              iconPath: "assets/images/javaicon2.png",
              isCompleted: _isJavaQ3Completed,
              isLocked: isQ3Locked, // Q3 locked if Q2 not done
              onTap: () async {
                if (isQ3Locked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You need to finish Quarter 2 first!"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JavaPreTestPage3()),
                );
                if (!mounted) return;
                _loadLessonCompletion();
              },
            ),
          ],
        ),
      ),
      // BOTTOM NAV BAR
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A3A5F),
          unselectedItemColor: Colors.black54,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == currentIndex) return;
            ref.read(currentTabIndexProvider.notifier).state = index;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainNavigator(
                  gameCode: 'defaultGameCode',
                  initialIndex: index,
                ),
              ),
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Home.png',
                width: 24,
                height: 24,
                color: currentIndex == 0
                    ? const Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Courses.png',
                width: 24,
                height: 24,
                color: currentIndex == 1
                    ? const Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Learn",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Leaderboard.png',
                width: 24,
                height: 24,
                color: currentIndex == 2
                    ? const Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Profile.png',
                width: 24,
                height: 24,
                color: currentIndex == 3
                    ? const Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  /// Build a quarter card that shows:
  ///   - "XP +50" if incomplete & unlocked
  ///   - "Locked" icon if locked
  ///   - "Completed" if finished
  Widget _quarterCard({
    required String title,
    required String description,
    required String iconPath,
    required bool isCompleted,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white38),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon + Title
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            // Right side: locked, completed, or XP +50
            if (isLocked)
              // Show a lock icon/badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.lock, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      "Locked",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else if (isCompleted)
              // Completed
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Completed",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              )
            else
              // Not locked, not completed => show XP +50
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF475E7E),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "XP\n+50",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
