import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quackacademy/main.dart';
import 'package:quackacademy/screens/home_page.dart';
import 'package:quackacademy/screens/login_page.dart';
import 'package:quackacademy/screens/profile_page.dart';
import 'package:quackacademy/screens/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Adjust path accordingly

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign-up method with Firestore user document creation.
  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    String username,
    String birthDate,
    String role,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User created with UID: ${userCredential.user!.uid}");

      try {
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "firstName": firstName,
          "lastName": lastName,
          "username": username,
          "email": email,
          "birthDate": birthDate,
          "role": role,
          "exp": 0,
          "level": 1,
          "createdAt": FieldValue.serverTimestamp(),
        });
        print(
            "User document created successfully for UID: ${userCredential.user!.uid}");
      } catch (firestoreError) {
        print("Error creating user document: $firestoreError");
        rethrow;
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error signing up: ${e.message}');
      }
      return null;
    } catch (e) {
      print('An unexpected error occurred during sign-up: $e');
      return null;
    }
  }

  /// Sign-in method.
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("User signed in with UID: ${userCredential.user!.uid}");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error signing in: ${e.message}');
      }
      return null;
    } catch (e) {
      print('An unexpected error occurred during sign-in: $e');
      return null;
    }
  }

  /// Sign-out method with optional Riverpod provider invalidation.
Future<void> signOut({WidgetRef? ref}) async {
  await _auth.signOut();
  print("✅ User signed out");

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('profileImagePath');

  if (ref != null) {
    // Keep invalidating local loading and data providers
    ref.invalidate(signUpLoadingProvider);
    ref.invalidate(loginLoadingProvider);
    ref.invalidate(userDataProvider);
    ref.invalidate(profileDataProvider);
    print("✅ Providers invalidated after sign-out (except authStateChangesProvider)");
  }
}

  /// Get current user.
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
