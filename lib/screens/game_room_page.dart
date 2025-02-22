import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameRoomPage extends StatefulWidget {
  final String gameCode;
  final bool isTeacher;
  final String playerName; // ✅ Player name passed from JoinPage

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    _setupUser();
  }

  void _setupUser() async {
    final user = _auth.currentUser;
    userId = widget.playerName; // ✅ Use the passed player name

    await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(userId)
        .set({
      'name': widget.playerName,
      'ready': false,
    }, SetOptions(merge: true));
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

  /// ✅ Exit Room
  void _exitRoom() async {
    await _firestore
        .collection('rooms')
        .doc(widget.gameCode)
        .collection('players')
        .doc(userId)
        .delete();

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

  /// ✅ Real-Time Player List
  Widget _buildPlayerList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('rooms')
            .doc(widget.gameCode)
            .collection('players')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final players = snapshot.data!.docs;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                final playerName = player['name'];
                final isPlayerReady = player['ready'];

                return Container(
                  decoration: BoxDecoration(
                    color: isPlayerReady ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Text(
                      "#${index + 1}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      playerName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPlayerReady ? Colors.green : Colors.red,
                      ),
                    ),
                    trailing: Icon(
                      isPlayerReady ? Icons.check_circle : Icons.cancel,
                      color: isPlayerReady ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// ✅ Footer with Game Code and Ready Button
  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          ElevatedButton(
            onPressed: _toggleReady,
            style: ElevatedButton.styleFrom(
              backgroundColor: isReady ? Colors.green : Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              isReady ? "Ready" : "Not Ready",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _exitRoom,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Exit Room",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
