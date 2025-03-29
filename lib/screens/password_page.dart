import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to manage loading state for the password page.
final passwordLoadingProvider = StateProvider<bool>((ref) => false);

class PasswordPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends ConsumerState<PasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;

  /// Re-authenticate user before changing password.
  Future<bool> _reAuthenticate(String currentPassword) async {
    try {
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user!.reauthenticateWithCredential(cred);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Re-authentication failed. Check current password."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  /// Update password function.
  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String otpCode = _otpController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New passwords do not match."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password must be at least 6 characters."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Set loading state to true.
    ref.read(passwordLoadingProvider.notifier).state = true;

    try {
      bool isReAuthenticated = await _reAuthenticate(currentPassword);
      if (!isReAuthenticated) {
        ref.read(passwordLoadingProvider.notifier).state = false;
        return;
      }

      // (Optional) Verify OTP if integrated with external services.
      if (otpCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Enter the OTP Code (if required)."),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(passwordLoadingProvider.notifier).state = false;
        return;
      }

      // Update the password.
      await user!.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Updated Successfully."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Return to previous screen after success.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      ref.read(passwordLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(passwordLoadingProvider);
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            /// Back Button
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A3A5F)),
                onPressed: () => Navigator.pop(context),
                child: Text("Back"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Password",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            /// Form Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTextField("Current Password", _currentPasswordController, obscureText: true),
                  _buildTextField("New Password", _newPasswordController, obscureText: true),
                  _buildTextField("Confirm Password", _confirmPasswordController, obscureText: true),
                  _buildTextField("OTP CODE (if required)", _otpController, obscureText: false),
                  SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator(color: Color(0xFF1A3A5F))
                      : ElevatedButton(
                          onPressed: _changePassword,
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A3A5F)),
                          child: Text("Confirm"),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable TextField Builder.
  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
