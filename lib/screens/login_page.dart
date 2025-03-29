import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quackacademy/main.dart';
import 'package:quackacademy/main_navigator.dart';
import 'package:quackacademy/screens/home_page.dart';
import 'package:quackacademy/screens/profile_page.dart';
import 'signup_page.dart';

// Riverpod providers for managing login page state.
final loginObscurePasswordProvider = StateProvider<bool>((ref) => true);
final loginLoadingProvider = StateProvider<bool>((ref) => false);

class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Toggle password visibility using Riverpod.
  void _togglePasswordVisibility() {
    ref.read(loginObscurePasswordProvider.notifier).update((state) => !state);
  }

  /// Handle user login and update the loading state via Riverpod.
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      // Optional: Sign out any previous user to ensure clean state.
      await FirebaseAuth.instance.signOut();

      // Attempt sign-in
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.reload(); // Refresh the user data explicitly

      // Explicitly invalidate Riverpod providers here:
      ref.invalidate(authStateChangesProvider);
      ref.invalidate(userDataProvider);
      ref.invalidate(profileDataProvider); // <--- ADD THIS LINE TOO

      // Force a refresh of the current user data.
      await _auth.currentUser?.reload();

      // Invalidate authStateChangesProvider to force rebuilds.
      ref.invalidate(authStateChangesProvider);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigator(gameCode: 'defaultGameCode'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login failed"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(loginLoadingProvider);
    final bool obscurePassword = ref.watch(loginObscurePasswordProvider);

    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/duck_logo.png', height: 100),
                SizedBox(height: 10),
                // App Name
                Text(
                  "QUACKADEMY",
                  style: TextStyle(
                    fontFamily: 'Jaro',
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Login Heading
                Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: 'Jaro',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Login Form
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Input
                      Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Password Input
                      Text("Password:", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      TextField(
                        controller: _passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Login Button or Loading Spinner
                      SizedBox(
                        width: double.infinity,
                        child: isLoading
                            ? Center(child: CircularProgressIndicator(color: Color(0xFF1A3A5F)))
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1A3A5F),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _login,
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Sign Up Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        "Sign up here",
                        style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
