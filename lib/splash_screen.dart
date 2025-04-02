import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quackacademy/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/images/Lottie/Animation - 1743523201612.json",
          ),
        ],
      ),
      nextScreen: AuthWrapper(), // Navigate to your auth handler
      splashIconSize: 500,
      backgroundColor: const Color(0xFF1A3A5F),
    );
  }
}
