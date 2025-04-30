import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        const SnackBar(
          content: Text("Please enter email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      // Optional but useful if you're switching accounts
      await FirebaseAuth.instance.signOut();

      // Sign in
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // No need to reload user or manually invalidate authStateChangesProvider

      // Invalidate other app-specific providers to refresh state
      ref.invalidate(userDataProvider);
      ref.invalidate(profileDataProvider);

      // Navigate to main screen
      if (!context.mounted) return;
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
                Image.asset('assets/images/duck_logo2.png', height: 100),
                SizedBox(height: 10),
                // App Name
                Text(
                  "QuackAcademy",
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
                  "WELCOME",
                  style: TextStyle(
                    fontFamily: 'Jaro',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Login Heading
                Text(
                  "Sign In to continue",
                  style: TextStyle(
                    fontFamily: 'Jaro',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Login Form - Redesigned without grey card but still aligned beautifully
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ——— Email Field ———
                      TextField(
                        controller: _emailController,
                        style: TextStyle(
                            color: Colors.white), // Text color inside input
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Colors.white70), // Placeholder lighter
                          filled: true,
                          fillColor: Color(
                              0xFF1A3A5F), // Same as background but use subtle border
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.white70, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFF476F95), width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                        ),
                      ),
                      SizedBox(height: 16),

                      // ——— Password Field ———
                      TextField(
                        controller: _passwordController,
                        obscureText: obscurePassword,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Color(0xFF1A3A5F),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.white70, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFF476F95), width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // ——— Sign In Button ———
                      SizedBox(
                        height: 50,
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFF476F95)))
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF476F95),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _login,
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 254, 254, 254), // Button text dark blue
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
                    Text("Don't have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        "Sign up here",
                        style: TextStyle(
                            color: Colors.yellow, fontWeight: FontWeight.bold),
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
