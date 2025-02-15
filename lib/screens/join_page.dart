import 'package:flutter/material.dart';
import 'package:quackacademy/widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../theme.dart';

class JoinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/duck_logo.png', height: 100),
            SizedBox(height: 20),
            Text("Get Ready to Join! QUACKADEMY", style: AppTheme.themeData.textTheme.titleLarge, textAlign: TextAlign.center),
            SizedBox(height: 20),
            CustomTextField(label: "Enter Code"),
            CustomTextField(label: "Enter Name"),
            SizedBox(height: 20),
            CustomButton(text: "Join Now", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
