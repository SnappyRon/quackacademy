import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quackacademy/models/course_model.dart';

/// Streams the list of courses, ordered by title.
final coursesProvider = StreamProvider<List<CourseModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('courses')
      .orderBy('title')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => CourseModel.fromDoc(doc)).toList());
});

/// Fetches the current user's role ("teacher", "student", etc.) from Firestore.
final userRoleProvider = FutureProvider<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'guest';
  final snap = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  final data = snap.data();
  return (data != null && data['role'] is String)
      ? data['role'] as String
      : 'student';
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
    final roleAsync = ref.watch(userRoleProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: roleAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text("Error: $err")),
            data: (role) {
              final isTeacher = role == 'teacher';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: coursesAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text("Error: $err")),
                      data: (courses) {
                        return ListView(
                          children: [
                            for (final course in courses)
                              _buildCourseCard(
                                  context, course, isAddButton: false),
                            if (isTeacher)
                              _buildCourseCard(
                                  context, null, isAddButton: true),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
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
                fontFamily: 'Jaro',
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
                'assets/images/java.png',
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported,
                        color: Colors.red, size: 40),
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
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) return;
            final enrollmentDoc = await FirebaseFirestore.instance
                .collection('courses')
                .doc(course!.id)
                .collection('enrollments')
                .doc(user.uid)
                .get();

            if (enrollmentDoc.exists) {
              Navigator.pushNamed(
                context,
                '/JavaCourseSelectionPage',
                arguments: course,
              );
            } else {
              _showEnrollConfirmation(context, course);
            }
          }
        },
      ),
    );
  }

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

              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();
              final fullName =
                  "${userDoc['firstName']} ${userDoc['lastName']}".trim();

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

              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();
              final learnerName =
                  userDoc.data()?['username'] ?? 'No Name';
              final learnerEmail =
                  userDoc.data()?['email'] ?? 'No Email';

              final enrollmentRef = FirebaseFirestore.instance
                  .collection('courses')
                  .doc(course.id)
                  .collection('enrollments')
                  .doc(user.uid);

              await enrollmentRef.set({
                'userId': user.uid,
                'name': learnerName,
                'email': learnerEmail,
                'enrolledAt': FieldValue.serverTimestamp(),
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("You've enrolled in ${course.title}!")),
              );

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
