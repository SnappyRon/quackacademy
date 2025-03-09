import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizReviewPage extends StatelessWidget {
  final String quizId;
  const QuizReviewPage({required this.quizId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review Quiz"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(quizId)
            .collection('slides')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No quiz data found."));
          }

          final slides = snapshot.data!.docs;

          return ListView.builder(
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final data = slides[index].data() as Map<String, dynamic>;
              final question = data['question'] ?? 'No question';
              final answers = List<String>.from(data['answers'] ?? []);
              final correctAnswer = data['correctAnswer'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Q${index + 1}: $question",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: answers.map((ans) {
                          final isCorrect = (ans == correctAnswer);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isCorrect ? Colors.green[100] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.circle,
                                  color: isCorrect ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ans,
                                    style: TextStyle(
                                      color: isCorrect ? Colors.green[800] : Colors.black,
                                      fontWeight:
                                          isCorrect ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
