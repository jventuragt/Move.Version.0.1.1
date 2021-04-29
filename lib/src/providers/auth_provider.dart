import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider {
  FirebaseAuth _firebaseAuth;

  AuthProvider() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User getUser() {
    return _firebaseAuth.currentUser;
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      return false;
    }
    return true;
  }

  void checkIfIserIsLogged(BuildContext context, String typeUser) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user != null && typeUser != null) {
        if (typeUser == "client") {
          Navigator.pushNamedAndRemoveUntil(
              context, "client/map", (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, "driver/map", (route) => false);
        }
        print("Usuario Logeado");
      } else {
        print("Usuario no Logeado");
      }
    });
  }

  Future<bool> login(String email, String password) async {
    String errorMesage;

    try {
//
//
//
//
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
//
//
    } catch (error) {
      print(error);
//
//
//
      errorMesage = error.code;
    }

    if (errorMesage != null) {
      return Future.error(errorMesage);
    }
//
//
//
    return true;
  }

  Future<bool> register(String email, String password) async {
    String errorMesage;

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);

      errorMesage = error.code;
    }

    if (errorMesage != null) {
      return Future.error(errorMesage);
    }
    return true;
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }
}
