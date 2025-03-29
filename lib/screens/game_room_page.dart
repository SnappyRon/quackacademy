import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that streams the room document data.
final roomDocumentProvider = StreamProvider.family<DocumentSnapshot<Map<String, dynamic>>, String>((ref, gameCode) {
  return FirebaseFirestore.instance.collection('rooms').doc(gameCode).snapshots();
});

/// Provider that streams the players list for a room.
final playersProvider = StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>((ref, gameCode) {
  return FirebaseFirestore.instance
      .collection('rooms')
      .doc(gameCode)
      .collection('players')
      .snapshots();
});

/// Provider to manage the ready state of the current player.
final gameRoomReadyProvider = StateProvider<bool>((ref) => false);

class GameRoomPage extends ConsumerStatefulWidget {
  final String gameCode;
  final bool isTeacher;
  final String playerName;

  GameRoomPage({
    required this.gameCode,
    required this.isTeacher,
    required this.playerName,
  });

  @override
  ConsumerState<GameRoomPage> createState() => _GameRoomPageState();
}

class _GameRoomPageState extends ConsumerState<GameRoomPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String userId;
  bool _hasNavigated = false; // Prevent multiple navigations on game start.

  @override
  void initState() {
    super.initState();
    _setupGameRoom();
    // Removed ref.listen from here.
  }

  /// Ensure game room exists & initialize missing fields.
  void _setupGameRoom() async {
    final roomRef = _firestore.collection('rooms').doc(widget.gameCode);
    final roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      await roomRef.set({
        'gameStarted': false,
        'selectedQuiz': '',
        'requiredPlayers': 2, // Default required players.
        'admin': widget.playerName, // Store admin name.
      });
    }

    // For simplicity, we set userId to the provided player name.
    userId = widget.playerName;

    // If the user is a student, add them to the room.
    if (!widget.isTeacher) {
      await roomRef.collection('players').doc(userId).set({
        'name': widget.playerName,
        'ready': false,
      }, SetOptions(merge: true));
    }
  }

  /// Toggle Ready/Not Ready.
  void _toggleReady() async {
    // Toggle local ready state using Riverpod provider.
    ref.read(gameRoomReadyProvider.notifier).update((state) => !state);
    bool newReady = ref.read(gameRoomReadyProvider);
    await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(userId)
        .update({'ready': newReady});
  }

  /// Start Game (Only for Teacher).
  void _startGame() async {
    String? selectedQuizId = await _selectQuiz();
    if (selectedQuizId == null) return;

    await _firestore.collection('rooms').doc(widget.gameCode).update({
      'gameStarted': true,
      'selectedQuiz': selectedQuizId,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Game Started!"), backgroundColor: Colors.green),
    );
  }

  /// Quiz Selection Dialog.
  Future<String?> _selectQuiz() async {
    QuerySnapshot quizSnapshot = await _firestore.collection('quizzes').get();
    if (quizSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No quizzes available!"), backgroundColor: Colors.red),
      );
      return null;
    }

    List<String> quizTitles = quizSnapshot.docs.map((doc) => doc['title'] as String).toList();
    List<String> quizIds = quizSnapshot.docs.map((doc) => doc.id).toList();

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select a Quiz"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: quizTitles.map((title) {
              int index = quizTitles.indexOf(title);
              return ListTile(
                title: Text(title),
                onTap: () {
                  Navigator.pop(context, quizIds[index]);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Exit Room.
  void _exitRoom() async {
    if (!widget.isTeacher) {
      await _firestore
          .collection('rooms')
          .doc(widget.gameCode)
          .collection('players')
          .doc(userId)
          .delete();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for room document changes in the build method.
    ref.listen(roomDocumentProvider(widget.gameCode), (previous, next) {
      if (next is AsyncData) {
        final data = next.value?.data();
        bool gameStarted = data?['gameStarted'] ?? false;
        String quizId = data?['selectedQuiz'] ?? '';
        if (gameStarted && quizId.isNotEmpty && !_hasNavigated) {
          _hasNavigated = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                gameCode: widget.gameCode,
                quizId: quizId,
                currentPlayerId: userId,
                isTeacher: widget.isTeacher,
              ),
            ),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildAdminInfo(),
            _buildPlayerList(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// Header with Duck Logo and Title.
  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 20),
        Image.asset('assets/images/duck_logo.png', height: 60),
        SizedBox(height: 10),
        Text(
          "QUACKACADEMY",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  /// Display Admin Info (Teacher Name).
  Widget _buildAdminInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF1A3A5F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Role: ${widget.playerName}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  /// Real-Time Player List using Riverpod.
  Widget _buildPlayerList() {
    final playersAsync = ref.watch(playersProvider(widget.gameCode));
    return Expanded(
      child: playersAsync.when(
        data: (snapshot) {
          final players = snapshot.docs;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                final playerName = player['name'];
                final isPlayerReady = player['ready'];
                return ListTile(
                  title: Text(
                    playerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isPlayerReady ? Colors.green : Colors.red,
                    ),
                  ),
                  trailing: widget.playerName == playerName
                      ? ElevatedButton(
                          onPressed: _toggleReady,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPlayerReady ? Colors.green : Color(0xFF1A3A5F),
                          ),
                          child: Text(
                            isPlayerReady ? "Ready" : "Not Ready",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Icon(
                          isPlayerReady ? Icons.check_circle : Icons.cancel,
                          color: isPlayerReady ? Colors.green : Colors.red,
                        ),
                );
              },
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error loading players")),
      ),
    );
  }

  /// Footer with Game Code & Start Button.
  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Game Code: ${widget.gameCode}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          if (widget.isTeacher)
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFF476F95),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Start Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
