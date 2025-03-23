import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackacademy/screens/setup_quiz_page.dart';
import 'dart:math';
import 'game_room_page.dart'; // ✅ Import GameRoomPage
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSessionPage extends ConsumerWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String gameCode;

  CreateSessionPage({Key? key})
      : gameCode = _generateGameCode(),
        super(key: key);

  static String _generateGameCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rand = Random();
    return List.generate(5, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  /// Create Room in Firestore and navigate to GameRoomPage.
  Future<void> _createRoom(BuildContext context) async {
    // Create the room in Firestore with the generated gameCode.
    await _firestore.collection('rooms').doc(gameCode).set({
      'gameCode': gameCode,
      'createdAt': Timestamp.now(),
    });

    // Show confirmation.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Room Created with Code: $gameCode"), backgroundColor: Colors.green),
    );

    // Navigate to GameRoomPage with playerName = "Teacher".
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameRoomPage(
          gameCode: gameCode,
          isTeacher: true, // Assuming the creator is the teacher.
          playerName: "Teacher", // ✅ Pass playerName.
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      _buildLogoSection(),
                      const SizedBox(height: 20),
                      _buildSessionContainer(
                        title: "Unlock a seamless experience\ncreate your session now and take control!",
                        codeLabel: "Game Code: $gameCode",
                        buttonText: "Create Room >",
                        onPressed: () => _createRoom(context),
                      ),
                      const SizedBox(height: 20),
                      _buildSessionContainer(
                        title: "Turn learning into fun\nbuild your quiz in minutes!",
                        codeLabel: "",
                        buttonText: "Create Quiz >",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SetupQuizPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /// Back Button (Top-Left)
            Positioned(
              top: 10,
              left: 10,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
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
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Duck Logo and Header.
  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset(
          'assets/images/duck_logo.png', // Ensure this exists.
          height: 120,
        ),
        const SizedBox(height: 10),
        const Text(
          "GET READY TO JOIN!\nQUACKACADEMY",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  /// Session Container (Gray Box).
  Widget _buildSessionContainer({
    required String title,
    required String codeLabel,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.3,
            ),
          ),
          if (codeLabel.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              codeLabel,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              elevation: 4,
              side: const BorderSide(color: Colors.black, width: 1),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
