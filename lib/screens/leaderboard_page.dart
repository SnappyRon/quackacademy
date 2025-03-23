import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackacademy/main_navigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for student leaderboard data.
final studentLeaderboardProvider = StreamProvider.family<QuerySnapshot, String>((ref, gameCode) {
  return FirebaseFirestore.instance
      .collection('rooms')
      .doc(gameCode)
      .collection('players')
      .orderBy('points', descending: true)
      .snapshots();
});

/// Provider for teacher view fallback data (when quizId is empty).
final teacherPlayersProvider = StreamProvider.family<QuerySnapshot, String>((ref, gameCode) {
  return FirebaseFirestore.instance
      .collection('rooms')
      .doc(gameCode)
      .collection('players')
      .orderBy('points', descending: true)
      .snapshots();
});

/// Provider for quiz sessions when a quizId is provided.
final quizSessionsProvider = StreamProvider.family<QuerySnapshot, String>((ref, quizId) {
  return FirebaseFirestore.instance
      .collection('quizSessions')
      .where(FieldPath.documentId, isEqualTo: quizId)
      .snapshots();
});

/// Provider for a session's leaderboard.
final sessionLeaderboardProvider = StreamProvider.family<QuerySnapshot, DocumentReference>((ref, sessionRef) {
  return sessionRef
      .collection('leaderboard')
      .orderBy('score', descending: true)
      .snapshots();
});

class LeaderboardPage extends ConsumerWidget {
  final bool isTeacher;
  final String currentPlayerId;
  final String quizId; // For teacher view (if provided)
  final String gameCode; // Used to query room players

  LeaderboardPage({
    required this.isTeacher,
    required this.currentPlayerId,
    required this.quizId,
    required this.gameCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _buildBackButton(context),
            _buildLogoSection(),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isTeacher ? _buildTeacherView(ref) : _buildStudentView(ref),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build student view using the studentLeaderboardProvider.
  Widget _buildStudentView(WidgetRef ref) {
    final leaderboardAsync = ref.watch(studentLeaderboardProvider(gameCode));
    return leaderboardAsync.when(
      data: (snapshot) {
        if (snapshot.docs.isEmpty) {
          return const Center(child: Text("No leaderboard data found"));
        }
        return Column(
          children: [
            _buildHeaderRow(),
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  return _buildStudentLeaderboardRow(snapshot.docs[index], index);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Error: $error")),
    );
  }

  /// Build teacher view using either quizSessionsProvider or teacherPlayersProvider.
  Widget _buildTeacherView(WidgetRef ref) {
    if (quizId.isNotEmpty) {
      final sessionsAsync = ref.watch(quizSessionsProvider(quizId));
      return sessionsAsync.when(
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text("No quiz sessions found."));
          }
          return ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, sessionIndex) {
              final sessionDoc = snapshot.docs[sessionIndex];
              final sessionData = sessionDoc.data() as Map<String, dynamic>;
              final sessionTitle = sessionData['quizTitle'] ?? 'Quiz Session';
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ExpansionTile(
                  title: Text(
                    sessionTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    _buildHeaderRow(), // Leaderboard header.
                    // Use a nested Consumer to watch the session leaderboard.
                    Consumer(
                      builder: (context, ref, _) {
                        final sessionLeaderboardAsync =
                            ref.watch(sessionLeaderboardProvider(sessionDoc.reference));
                        return sessionLeaderboardAsync.when(
                          data: (leaderboardSnapshot) {
                            if (leaderboardSnapshot.docs.isEmpty) {
                              return const Center(child: Text("No players in this session."));
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: leaderboardSnapshot.docs.length,
                              itemBuilder: (context, index) {
                                return _buildTeacherLeaderboardRow(leaderboardSnapshot.docs[index], index);
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => Center(child: Text("Error: $error")),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      );
    } else {
      final leaderboardAsync = ref.watch(teacherPlayersProvider(gameCode));
      return leaderboardAsync.when(
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text("No leaderboard data found"));
          }
          return ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              return _buildTeacherLeaderboardRow(snapshot.docs[index], index);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      );
    }
  }

  /// Header row used in both views.
  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: const [
          Expanded(
            flex: 3,
            child: Text(
              "Player",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Rank",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Quiz Title",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Score",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a row for a student leaderboard entry.
  Widget _buildStudentLeaderboardRow(DocumentSnapshot doc, int index) {
    final data = doc.data() as Map<String, dynamic>;
    final playerName = data['name'] ?? 'No Name';
    final score = data['points'] ?? 0;
    final quizTitle = data['quizTitle'] ?? 'Quiz Session';
    final imagePath = data['image'] ?? 'assets/images/Student1.png';
    final rank = index + 1;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
        color: (rank == 1) ? Colors.blue[100] : Colors.white,
      ),
      child: Row(
        children: [
          // Player (profile image + name)
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(imagePath),
                  radius: 16,
                  onBackgroundImageError: (_, __) =>
                      const Icon(Icons.error, color: Colors.red, size: 16),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    playerName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Rank
          Expanded(
            flex: 1,
            child: Text(
              "$rank",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Quiz Title
          Expanded(
            flex: 3,
            child: Text(
              quizTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Score
          Expanded(
            flex: 1,
            child: Text(
              "$score",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (rank == 1) ? Colors.blue : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a row for a teacher view leaderboard entry.
  Widget _buildTeacherLeaderboardRow(DocumentSnapshot doc, int index) {
    final data = doc.data() as Map<String, dynamic>;
    final playerName = data['name'] ?? 'No Name';
    final score = data['score'] ?? 0;
    final quizTitle = data['quizTitle'] ?? 'Quiz Session';
    final imagePath = data['image'] ?? 'assets/images/Student1.png';
    final rank = index + 1;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
        color: (rank == 1) ? Colors.blue[100] : Colors.white,
      ),
      child: Row(
        children: [
          // Player (profile image + name)
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(imagePath),
                  radius: 16,
                  onBackgroundImageError: (_, __) =>
                      const Icon(Icons.error, color: Colors.red, size: 16),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    playerName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Rank
          Expanded(
            flex: 1,
            child: Text(
              "$rank",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Quiz Title
          Expanded(
            flex: 3,
            child: Text(
              quizTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Score
          Expanded(
            flex: 1,
            child: Text(
              "$score",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (rank == 1) ? Colors.blue : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Back Button (Top-Left)
  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainNavigator(gameCode: 'defaultGameCode')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            "Back",
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Logo and Title Section.
  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset('assets/images/duck_logo.png', width: 80),
        const SizedBox(height: 5),
        const Text(
          "QUACKACADEMY",
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        ),
        const Text(
          "LEADERBOARDS",
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
