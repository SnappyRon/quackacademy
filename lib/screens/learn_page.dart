import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quackacademy/models/course_model.dart';

final coursesProvider = StreamProvider<List<CourseModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Return an empty stream if not authenticated.
    return Stream.value([]);
  } else {
    return FirebaseFirestore.instance
        .collection('courses')
        .orderBy('title')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CourseModel.fromDoc(doc)).toList());
  }
});

class LearnPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text("Please sign in to view courses"),
        ),
      );
    }

    final coursesAsync = ref.watch(coursesProvider);

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
                child: coursesAsync.when(
                  data: (courses) {
                    return ListView(
                      children: [
                        for (final course in courses)
                          _buildCourseCard(context, course, isAddButton: false),
                        _buildCourseCard(context, null, isAddButton: true),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Error: $e")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Courses",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Select a course to start learning!",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        Icon(Icons.school, color: Colors.white, size: 28),
      ],
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    CourseModel? course, {
    required bool isAddButton,
  }) {
    final title = isAddButton ? "Add course" : course!.title;
    final subtitle = isAddButton ? "Add a new course" : course!.description;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: isAddButton
            ? const Icon(Icons.add, size: 40, color: Color(0xFF476F95))
            : Image.asset(
                'assets/images/java.png', // Replace if dynamic
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, color: Colors.red, size: 40),
              ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: () async {
          if (isAddButton) {
            _showAddCourseDialog(context);
          } else {
            // Check if the student is already enrolled in the course.
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) return;
            final enrollmentDoc = await FirebaseFirestore.instance
                .collection('courses')
                .doc(course!.id)
                .collection('enrollments')
                .doc(user.uid)
                .get();

            if (enrollmentDoc.exists) {
              // Already enrolled: navigate directly to the course content page.
              Navigator.pushNamed(
                context,
                '/JavaCourseSelectionPage',
                arguments: course,
              );
            } else {
              // Not enrolled: show enrollment confirmation dialog.
              _showEnrollConfirmation(context, course);
            }
          }
        },
      ),
    );
  }

  /// Course creation dialog.
  void _showAddCourseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Course"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Course Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              final title = titleController.text.trim();
              final desc = descriptionController.text.trim();

              if (title.isEmpty || desc.isEmpty) return;

              // Get user profile name (optional)
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();
              final fullName = "${userDoc['firstName']} ${userDoc['lastName']}".trim();

              await FirebaseFirestore.instance.collection('courses').add({
                'title': title,
                'description': desc,
                'createdBy': user.uid,
                'creatorName': fullName,
                'learners': [],
                'createdAt': FieldValue.serverTimestamp(),
              });

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Course added to Firebase!")),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Enrollment confirmation dialog for students.
  void _showEnrollConfirmation(BuildContext context, CourseModel course) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Enroll in ${course.title}?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.description),
            const SizedBox(height: 8),
            Text("Instructor: ${course.creatorName ?? 'Unknown'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              // Retrieve the user's profile info from Firestore.
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();
              final learnerName = userDoc.data()?['username'] ?? 'No Name';
              final learnerEmail = userDoc.data()?['email'] ?? 'No Email';

              // Create the enrollment document in the subcollection using the student's UID.
              final enrollmentRef = FirebaseFirestore.instance
                  .collection('courses')
                  .doc(course.id)
                  .collection('enrollments')
                  .doc(user.uid);

              await enrollmentRef.set({
                'userId': user.uid, // Must match the security rule (doc id == user.uid)
                'name': learnerName,
                'email': learnerEmail,
                'enrolledAt': FieldValue.serverTimestamp(),
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("You've enrolled in ${course.title}!")),
              );

              // After enrollment, navigate to the JavaCourseSelectionPage.
              Navigator.pushNamed(
                context,
                '/JavaCourseSelectionPage',
                arguments: course,
              );
            },
            child: const Text("Enroll"),
          ),
        ],
      ),
    );
  }
}
