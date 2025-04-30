import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 👈 Added
import 'package:quackacademy/game/duck_race_game.dart';
import 'package:quackacademy/screens/courses/java_course/java_course_page.dart';
import 'package:quackacademy/screens/learn_page.dart';
import 'package:quackacademy/splash_screen.dart';
import 'firebase_options.dart';
import 'package:quackacademy/screens/login_page.dart';
import 'package:quackacademy/screens/signup_page.dart';
import 'package:quackacademy/screens/home_page.dart';
import 'package:quackacademy/screens/join_page.dart';
import 'package:quackacademy/screens/profile_page.dart';
import 'package:quackacademy/screens/information_page.dart';
import 'package:quackacademy/screens/password_page.dart';
import 'package:quackacademy/main_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final prefs = await SharedPreferences.getInstance();
  bool? isFirstTime = prefs.getBool("isFirstTime");
  if (isFirstTime == null) {
    await prefs.setBool("isFirstTime", false);
    await FirebaseAuth.instance.signOut();
  }

  runApp(ProviderScope(child: QuackAcademyApp()));
}

class QuackAcademyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // 👈 Base design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: SplashScreen(),
          routes: {
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignUpPage(),
            '/home': (context) => HomePage(),
            '/join': (context) => JoinPage(),
            '/profile': (context) => ProfilePage(),
            '/information': (context) => InformationPage(),
            '/password': (context) => PasswordPage(),
            '/learn': (context) => LearnPage(),
            '/main': (context) => MainNavigator(gameCode: 'defaultGameCode'),
            '/JavaCourseSelectionPage': (context) =>
                JavaCourseSelectionPage(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return MainNavigator(
              key: ValueKey(user.uid), gameCode: 'defaultGameCode');
        } else {
          return LoginPage();
        }
      },
      loading: () =>
          Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Something went wrong!'))),
    );
  }
}
