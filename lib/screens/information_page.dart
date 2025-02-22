import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _otpController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  /// ✅ Fetch existing user data from Firestore
  void _fetchUserInfo() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _fullNameController.text = userDoc['fullName'] ?? '';
            _nicknameController.text = userDoc['nickname'] ?? '';
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

  /// ✅ Update user info in Firestore & Firebase Auth
  void _updateInfo() async {
    setState(() => _isLoading = true);

    try {
      if (user != null) {
        /// ✅ Update Email in FirebaseAuth if changed
        if (_emailController.text.trim() != user!.email) {
          await user!.updateEmail(_emailController.text.trim());
        }

        /// ✅ Update Firestore Document
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'fullName': _fullNameController.text.trim(),
          'nickname': _nicknameController.text.trim(),
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Back Button
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Back"),
                ),
              ),
              SizedBox(height: 20),

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
                    _buildTextField("Nickname", _nicknameController),
                    _buildTextField("Email", _emailController),
                    _buildTextField("Birth Date", _birthDateController),
                    _buildTextField("OTP CODE", _otpController), // Optional for added security

                    SizedBox(height: 20),

                    /// Confirm Button
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.orange)
                        : ElevatedButton(
                            onPressed: _updateInfo,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 18)),
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

  /// 📋 Reusable TextField Builder
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
