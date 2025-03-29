import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String? creatorName;
  final List<dynamic> learners;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.learners,
    this.creatorName,
  });

  factory CourseModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdBy: data['createdBy'] ?? '',
      creatorName: data['creatorName'],
      learners: data['learners'] ?? [],
    );
  }
}
