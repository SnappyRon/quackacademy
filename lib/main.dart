import 'package:flutter/material.dart';
import 'screens/signup_page.dart';
import 'theme.dart';

void main() {
  runApp(QuackAcademyApp());
}

class QuackAcademyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: SignUpPage(),
    );
  }
}
