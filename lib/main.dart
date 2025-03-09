import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quackacademy/game/duck_race_game.dart';
import 'package:quackacademy/screens/learn_page.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/join_page.dart'; // ✅ Import JoinPage
import 'screens/profile_page.dart';
import 'screens/information_page.dart'; // ✅ Import InformationPage
import 'screens/password_page.dart'; // ✅ Import PasswordPage
import 'main_navigator.dart'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print("🔥 Firebase initialization error: $e");
  }

  runApp(QuackAcademyApp());
}

class QuackAcademyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MainNavigator(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/join': (context) => JoinPage(), // ✅ Added JoinPage route
        '/profile': (context) => ProfilePage(), // ✅ ProfilePage route
        '/information': (context) => InformationPage(), // ✅ InformationPage route
        '/password': (context) => PasswordPage(),
        '/learn': (context) => LearnPage(), // ✅ PasswordPage route
        '/main': (context) => MainNavigator(), // 
      },
    );
  }
}

/// ✅ This widget decides which page to show based on auth state
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return HomePage(); // ✅ User is logged in
        } else {
          return LoginPage(); // ✅ User is NOT logged in
        }
      },
    );
  }
}
