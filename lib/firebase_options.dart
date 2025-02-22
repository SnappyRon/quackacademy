import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: "AIzaSyAmmMnxLzHg-jM_lmckdqh_fHJuY8GoIC4",
      appId: "1:725109404811:web:your-web-app-id",
      messagingSenderId: "725109404811",
      projectId: "quackacademy-8709e",
      storageBucket: "quackacademy-8709e.appspot.com", // If applicable
    );
  }
}
