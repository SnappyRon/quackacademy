import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color primaryColor = Color(0xFF1E3A5F); // Dark Blue Background
  static Color textColor = Colors.white;
  static Color buttonColor = Color(0xFF1A3A5F);
  static Color textFieldFill = Colors.white; // Added missing property
  static Color textFieldBorder = Colors.grey.shade400; // Added missing property

  static ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
      bodyLarge: GoogleFonts.poppins(color: textColor, fontSize: 16, fontWeight: FontWeight.normal), // Fixed
      bodyMedium: GoogleFonts.poppins(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal), // Fixed
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      ),
    ),
  );

  static Color progressBarColor = Colors.blue; // Added default color
}
