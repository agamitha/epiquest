import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAHT89eDpPdgMHhysum1lFYHlKgOHUsNyE",
            authDomain: "epiquest-1e2c3.firebaseapp.com",
            projectId: "epiquest-1e2c3",
            storageBucket: "epiquest-1e2c3.firebasestorage.app",
            messagingSenderId: "283281344615",
            appId: "1:283281344615:web:2ae670dfe9c490a6402cc2"));
  } else {
    await Firebase.initializeApp();
  }
}
