import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_room_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage loading state when joining a session.
final joinSessionLoadingProvider = StateProvider<bool>((ref) => false);

class JoinPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends ConsumerState<JoinPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  /// Function to join session.
  void _joinSession() async {
    // Set loading state to true.
    ref.read(joinSessionLoadingProvider.notifier).state = true;

    String code = _codeController.text.trim().toUpperCase();
    String name = _nameController.text.trim();

    if (code.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.red),
      );
      ref.read(joinSessionLoadingProvider.notifier).state = false;
      return;
    }

    try {
      // Check if Room Exists.
      DocumentSnapshot roomSnapshot = await _firestore.collection('rooms').doc(code).get();

      if (!roomSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid Game Code"), backgroundColor: Colors.red),
        );
        return;
      }

      // Check for Existing Player with the Same Name.
      DocumentSnapshot playerSnapshot = await _firestore
          .collection('rooms')
          .doc(code)
          .collection('players')
          .doc(name)
          .get();

      if (playerSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Name already taken! Please choose another."), backgroundColor: Colors.red),
        );
        return;
      }

      // Add Player to Room.
      await _firestore.collection('rooms').doc(code).collection('players').doc(name).set({
        'name': name,
        'ready': false, // Default state as not ready.
      });

      // Show success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Joined session successfully!"), backgroundColor: Colors.green),
      );

      // Navigate to GameRoomPage with the joined player's name.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameRoomPage(
            gameCode: code,
            isTeacher: false,
            playerName: name, // Pass player name to Game Room.
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error joining session: $e"), backgroundColor: Colors.red),
      );
    } finally {
      ref.read(joinSessionLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(joinSessionLoadingProvider);
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Duck Logo.
                    Image.asset('assets/images/duck_logo.png', height: 100),
                    SizedBox(height: 20),

                    // Heading.
                    Text(
                      "GET READY TO JOIN!\nQUACKACADEMY",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Input Form.
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildCustomTextField("Enter Code:", _codeController),
                          SizedBox(height: 10),
                          _buildCustomTextField("Enter Name:", _nameController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Join Button.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  const Color(0xFF476F95),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        onPressed: isLoading ? null : _joinSession,
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Join Now",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.arrow_forward, color: Colors.white),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Back Button (Top-Left).
            Positioned(
              top: 10,
              left: 10,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF476F95),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  "Back",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom TextField Widget.
  Widget _buildCustomTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1A3A5F), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
