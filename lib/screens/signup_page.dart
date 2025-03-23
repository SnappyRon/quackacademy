import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

// Riverpod provider for loading state during sign up.
final signUpLoadingProvider = StateProvider<bool>((ref) => false);

class SignUpPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final AuthService authService = AuthService();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  /// ✅ New: Role TextField Controller
  final TextEditingController _roleController = TextEditingController();

  void _signUp() async {
    String fullName = _fullNameController.text.trim();
    String nickname = _nicknameController.text.trim();
    String email = _emailController.text.trim();
    String birthDate = _birthDateController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String role = _roleController.text.trim().toLowerCase(); // e.g. "student" or "teacher"

    // Input validation
    if (fullName.isEmpty ||
        nickname.isEmpty ||
        email.isEmpty ||
        birthDate.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.red),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email"), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match"), backgroundColor: Colors.red),
      );
      return;
    }

    // Set loading state to true.
    ref.read(signUpLoadingProvider.notifier).state = true;

    try {
      UserCredential? userCredential = await authService.signUpWithEmailAndPassword(
        email,
        password,
        fullName,
        nickname,
        birthDate,
      );

      if (userCredential != null) {
        // Update Firebase Auth user's displayName
        await userCredential.user?.updateDisplayName(fullName);
        await userCredential.user?.reload();

        // ✅ Also store the 'role' in Firestore document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName': fullName,
          'nickname': nickname,
          'email': email,
          'birthDate': birthDate,
          'role': role, // <-- New Field
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup successful! Please log in."), backgroundColor: Colors.green),
        );

        // Redirect to Login Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed! Try again."), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
      );
    } finally {
      // Set loading state to false.
      ref.read(signUpLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(signUpLoadingProvider);
    
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F), // Dark Blue Background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Back", style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 10),

                // Duck Logo
                Image.asset('assets/images/duck_logo.png', height: 100),
                SizedBox(height: 10),

                // App Name
                Text(
                  "QUACKADEMY",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 20),

                // Sign-up Title
                Text(
                  "Sign-up",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Form Container
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildCustomTextField("Full Name:", _fullNameController),
                      _buildCustomTextField("Nickname:", _nicknameController),
                      _buildCustomTextField("Email:", _emailController),
                      _buildCustomTextField("Birth Date:", _birthDateController),
                      _buildCustomTextField("Password:", _passwordController, obscureText: true),
                      _buildCustomTextField("Confirm Password:", _confirmPasswordController, obscureText: true),
                      /// ✅ New: Role Text Field
                      _buildCustomTextField("Role: (student or teacher)", _roleController),
                      SizedBox(height: 15),
                      isLoading
                          ? CircularProgressIndicator(color: Colors.orange)
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shadowColor: Colors.black,
                                  elevation: 4,
                                ),
                                onPressed: _signUp,
                                child: Text(
                                  "Submit",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom Text Field Builder
  Widget _buildCustomTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
