// current_quest_widget.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';

class CurrentQuestWidget extends StatelessWidget {
  const CurrentQuestWidget({super.key});

  Future<String> _getCurrentQuestTitle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Foundations of Java";

    final prefs = await SharedPreferences.getInstance();
    final uid = user.uid;

    bool isQ1Done = prefs.getBool("java_q1_completed_$uid") ?? false;
    bool isQ2Done = prefs.getBool("java_q2_completed_$uid") ?? false;
    bool isQ3Done = prefs.getBool("java_q3_completed_$uid") ?? false;

    if (!isQ1Done) {
      return "Foundations of Java";
    } else if (!isQ2Done) {
      return "Apply Basics of Java Language";
    } else if (!isQ3Done) {
      return "Advanced Java Topics";
    } else {
      return "All Java Quests Completed!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getCurrentQuestTitle(),
      builder: (context, snapshot) {
        final questTitle = snapshot.data ?? "Loading...";

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
              Text(
                questTitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF476F95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
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
            ],
          ),
        );
      },
    );
  }
}
