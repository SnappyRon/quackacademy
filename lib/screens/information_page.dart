import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage loading state for the InformationPage.
final informationLoadingProvider = StateProvider<bool>((ref) => false);

class InformationPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends ConsumerState<InformationPage> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _otpController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  /// Custom style based on the design image.
  final ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF5C7EA4),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    elevation: 0,
  );

  /// Fetch existing user data from Firestore.
  void _fetchUserInfo() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            String firstName = userDoc['firstName'] ?? '';
            String lastName = userDoc['lastName'] ?? '';
            _fullNameController.text = "$firstName $lastName".trim();
            _usernameController.text = userDoc['username'] ?? '';
            _emailController.text = userDoc['email'] ?? user!.email!;
            _birthDateController.text = userDoc['birthDate'] ?? '';
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching user data: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Update user info in Firestore & Firebase Auth.
  void _updateInfo() async {
    ref.read(informationLoadingProvider.notifier).state = true;
    try {
      if (user != null) {
        /// Update Email in FirebaseAuth if changed.
        if (_emailController.text.trim() != user!.email) {
          await user!.updateEmail(_emailController.text.trim());
        }

        // Split full name into first and last name
        List<String> nameParts = _fullNameController.text.trim().split(" ");
        String firstName = nameParts.isNotEmpty ? nameParts.first : "";
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

        /// Update Firestore Document.
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'birthDate': _birthDateController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Information Updated Successfully"), backgroundColor: Colors.green),
        );

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please re-authenticate and try again."), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Auth Error: ${e.message}"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      ref.read(informationLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(informationLoadingProvider);
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Back Button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    style: customButtonStyle,
                    onPressed: () => Navigator.pop(context),
                    child: Text("Back"),
                  ),
                ),
              ),
              SizedBox(height: 10),

              /// Title
              Text(
                "Information",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              /// Form
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildTextField("Full Name", _fullNameController),
                    _buildTextField("Username", _usernameController),
                    _buildTextField("Email", _emailController),
                    _buildTextField("Birth Date", _birthDateController),
                    _buildTextField("OTP CODE", _otpController),

                    SizedBox(height: 20),

                    /// Confirm Button
                    isLoading
                        ? CircularProgressIndicator(color: Color(0xFF5C7EA4))
                        : ElevatedButton(
                            onPressed: _updateInfo,
                            style: customButtonStyle,
                            child: Text("Confirm", style: TextStyle(fontSize: 18)),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildTextField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextField(
      controller: controller,
      style: TextStyle(fontSize: 16, color: Colors.black), // Input text
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.white, // Bright when it floats up
          backgroundColor: Color(0xFF1A3A5F), // Match your dark theme
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always, // Keeps it floating
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
    ),
  );
}

}
