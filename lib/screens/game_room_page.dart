import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_page.dart'; // ✅ Import Quiz Page

class GameRoomPage extends StatefulWidget {
  final String gameCode;
  final bool isTeacher;
  final String playerName;

  GameRoomPage({
    required this.gameCode,
    required this.isTeacher,
    required this.playerName,
  });

  @override
  _GameRoomPageState createState() => _GameRoomPageState();
}

class _GameRoomPageState extends State<GameRoomPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String userId;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    _setupGameRoom();
    _listenForGameStart();
  }

  /// ✅ Ensure game room exists & initialize missing fields
  void _setupGameRoom() async {
    final roomRef = _firestore.collection('rooms').doc(widget.gameCode);
    final roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      await roomRef.set({
        'gameStarted': false,
        'selectedQuiz': '',
        'requiredPlayers': 2, // Default required players
        'admin': widget.playerName, // ✅ Store admin name separately
      });
    }

    userId = widget.playerName;

    // ✅ Add player only if NOT a teacher
    if (!widget.isTeacher) {
      await roomRef.collection('players').doc(userId).set({
        'name': widget.playerName,
        'ready': false,
      }, SetOptions(merge: true));
    }
  }

  /// ✅ Toggle Ready/Not Ready
  void _toggleReady() async {
    setState(() {
      isReady = !isReady;
    });

    await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(userId)
        .update({'ready': isReady});
  }

  /// ✅ Listen for Game Start & Redirect Players
  void _listenForGameStart() {
    _firestore.collection('rooms').doc(widget.gameCode).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        bool gameStarted = snapshot.data()?['gameStarted'] ?? false;
        String quizId = snapshot.data()?['selectedQuiz'] ?? '';

        if (gameStarted && quizId.isNotEmpty) {
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
  }

  /// ✅ Start Game (Only for Teacher)
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

  /// ✅ Quiz Selection Dialog
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

  /// ✅ Exit Room
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

  /// ✅ Header with Duck Logo and Title
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

  /// ✅ Display Admin Info (Teacher Name)
  Widget _buildAdminInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Admin: ${widget.playerName}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  /// ✅ Real-Time Player List (White Background)
  Widget _buildPlayerList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('rooms').doc(widget.gameCode).collection('players').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final players = snapshot.data!.docs;

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
                            backgroundColor: isPlayerReady ? Colors.green : Colors.orange,
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
      ),
    );
  }

  /// ✅ Footer with Game Code & Start Button (Styled)
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
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Start Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
