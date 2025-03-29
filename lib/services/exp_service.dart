import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

int calculateLevel(int exp) {
  if (exp < 100) return 1;
  if (exp < 200) return 2;
  if (exp < 300) return 3;
  if (exp < 400) return 4;
  if (exp < 500) return 5;
  if (exp < 600) return 6;
  if (exp < 700) return 7;
  if (exp < 800) return 8;
  if (exp < 900) return 9;
  return 10;
}

class ExpService {
  static Future<void> awardExp(int points) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(doc);
        final currentExp = snapshot.data()?['exp'] as int? ?? 0;
        final newExp = currentExp + points;
        final newLevel = calculateLevel(newExp);
        transaction.update(doc, {'exp': newExp, 'level': newLevel});
      });
    } catch (e) {
      // Optionally, handle the error further or show an alert to the user.
      print("Error awarding exp: $e");
    }
  }
}
