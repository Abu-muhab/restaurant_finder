import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class AuthProvider extends ChangeNotifier {
  User? user;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<UserCredential> signup(String email, String password) async {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      return value;
    }).catchError((err) {
      throw err.message;
    });
  }
}
