import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../theme.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                /// **Back Button**
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Back", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                /// **Logo**
                Image.asset('assets/duck_logo.png', height: 100),
                
                SizedBox(height: 10),

                /// **Title**
                Text("QUACKADEMY", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),

                SizedBox(height: 10),

                /// **Sign-up Heading**
                Text("Sign-up", style: AppTheme.themeData.textTheme.titleLarge),
                
                SizedBox(height: 20),

                /// **Form Fields**
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CustomTextField(label: "Full Name"),
                      CustomTextField(label: "Nickname"),
                      CustomTextField(label: "Email"),
                      CustomTextField(label: "Birth Date"),
                      CustomTextField(label: "Password", obscureText: true),
                      CustomTextField(label: "Confirm Password", obscureText: true),
                      SizedBox(height: 15),
                      CustomButton(
                        text: "Submit",
                        onPressed: () {
                          Navigator.pushNamed(context, "/home");
                        },
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
}
