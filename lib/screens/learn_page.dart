import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'courses/java_course/java_course_page.dart';

class LearnPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    // Java course card
                    _buildCourseCard(
                      context,
                      "Java",
                      "Java fundamentals",
                      'assets/images/java.png',
                      false,
                    ),
                    // Add course card
                    _buildCourseCard(
                      context,
                      "Add course",
                      "Add a new course",
                      '', // Not used, since we'll display an icon instead
                      false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header Widget
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Courses",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            Text(
              "Select a course to start learning!",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        const Icon(Icons.school, color: Colors.orange, size: 28),
      ],
    );
  }

  /// Reusable Course Card
  Widget _buildCourseCard(
    BuildContext context,
    String title,
    String subtitle,
    String imagePath,
    bool isLocked,
  ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        // Show the Java image if it's "Java", otherwise show a plus icon
        leading: (title == "Add course")
            ? const Icon(Icons.add, size: 40, color: Colors.orange)
            : Image.asset(
                imagePath,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.red,
                  size: 40,
                ),
              ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: isLocked
            ? Image.asset(
                'assets/images/Lock.png',
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.lock,
                  color: Colors.red,
                  size: 30,
                ),
              )
            : null,
        onTap: () {
          if (!isLocked) {
            _handleCardTap(title, context);
          }
        },
      ),
    );
  }

  /// Handle card taps based on the title.
  void _handleCardTap(String courseName, BuildContext context) {
    if (courseName == "Java") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JavaCourseSelectionPage(),
        ),
      );
    } else if (courseName == "Add course") {
      // TODO: Implement your "Add course" action
      print("Add course tapped!");
    }
  }
}
