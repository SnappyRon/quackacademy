import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quackacademy/game/duck_race_game.dart';
import 'package:quackacademy/screens/learn_page.dart';
import 'firebase_options.dart';
import 'package:quackacademy/screens/login_page.dart';
import 'package:quackacademy/screens/signup_page.dart';
import 'package:quackacademy/screens/home_page.dart';
import 'package:quackacademy/screens/join_page.dart'; // ✅ Import JoinPage
import 'package:quackacademy/screens/profile_page.dart';
import 'package:quackacademy/screens/information_page.dart'; // ✅ Import InformationPage
import 'package:quackacademy/screens/password_page.dart'; // ✅ Import PasswordPage
import 'package:quackacademy/main_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Riverpod provider for auth state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

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

  // Check if this is a first-time installation.
  final prefs = await SharedPreferences.getInstance();
  bool? isFirstTime = prefs.getBool("isFirstTime");
  if (isFirstTime == null) {
    // Mark as not first-time for future runs
    await prefs.setBool("isFirstTime", false);
    // Force sign-out on a new installation
    await FirebaseAuth.instance.signOut();
  }

  // Wrap your app with ProviderScope to enable Riverpod.
  runApp(ProviderScope(child: QuackAcademyApp()));
}

class QuackAcademyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // Use AuthWrapper to decide which page to show based on auth state.
      home: AuthWrapper(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/join': (context) => JoinPage(), // ✅ Added JoinPage route
        '/profile': (context) => ProfilePage(), // ✅ ProfilePage route
        '/information': (context) =>
            InformationPage(), // ✅ InformationPage route
        '/password': (context) => PasswordPage(),
        '/learn': (context) => LearnPage(), // ✅ LearnPage route
        '/main': (context) => MainNavigator(gameCode: 'defaultGameCode'),
      },
    );
  }
}

/// This widget listens for authentication state changes and routes accordingly:
/// - If the user is logged in, it shows MainNavigator (session preserved across app restarts).
/// - If not, it shows LoginPage.
class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return MainNavigator(key: ValueKey(user.uid), gameCode: 'defaultGameCode');
        } else {
          return LoginPage();
        }
      },
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Something went wrong!'))),
    );
  }
}
