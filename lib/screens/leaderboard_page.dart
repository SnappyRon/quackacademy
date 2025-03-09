import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackacademy/main_navigator.dart';

class LeaderboardPage extends StatelessWidget {
  final bool isTeacher;
  final String currentPlayerId;
  final String quizId; // Used for student view (if needed)

  LeaderboardPage({
    required this.isTeacher,
    required this.currentPlayerId,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: isTeacher ? _buildTeacherView() : _buildStudentView(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// For students: Standard leaderboard view.
/// For students: Standard leaderboard view showing their quiz history.
Widget _buildStudentView() {
  return Column(
    children: [
      _buildHeaderRow(),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('studentHistory')
              .where('studentId', isEqualTo: currentPlayerId)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No leaderboard history found"));
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return _buildStudentLeaderboardRow(docs[index], index);
              },
            );
          },
        ),
      ),
    ],
  );
}

  /// For teacher: List of previous quiz sessions.
  /// For teacher: List of previous quiz sessions.
/// For teacher: List of previous quiz sessions (or a single session if quizId is provided).
Widget _buildTeacherView() {
  // If a quizId is provided (from teacher navigation), show only that session.
  final sessionQuery = (quizId.isNotEmpty)
      ? FirebaseFirestore.instance
          .collection('quizSessions')
          .where(FieldPath.documentId, isEqualTo: quizId)
          .snapshots()
      : FirebaseFirestore.instance
          .collection('quizSessions')
          .orderBy('date', descending: true)
          .snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: sessionQuery,
    builder: (context, sessionSnapshot) {
      if (sessionSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!sessionSnapshot.hasData || sessionSnapshot.data!.docs.isEmpty) {
        return const Center(child: Text("No quiz sessions found."));
      }
      final sessions = sessionSnapshot.data!.docs;
      return ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, sessionIndex) {
          final sessionData =
              sessions[sessionIndex].data() as Map<String, dynamic>;
          final sessionTitle = sessionData['quizTitle'] ?? 'Quiz Session';
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: ExpansionTile(
              title: Text(
                sessionTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                _buildHeaderRow(), // Header for the leaderboard inside the session.
                StreamBuilder<QuerySnapshot>(
                  stream: sessions[sessionIndex].reference
                      .collection('leaderboard')
                      .orderBy('score', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text("No players in this session."));
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return _buildTeacherLeaderboardRow(docs[index], index);
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
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
    final score = data['score'] ?? 0;
    // Use the provided quizTitle field if available; otherwise use a fallback.
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
    // For teacher view, assume the quiz title comes from the parent session.
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
          // Quiz Title (from session header; optional here)
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
                MaterialPageRoute(builder: (context) => MainNavigator()),
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// Logo and Title Section
  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset('assets/images/duck_logo.png', width: 80),
        const SizedBox(height: 5),
        const Text(
          "QUACKACADEMY",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const Text(
          "LEADERBOARDS",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
