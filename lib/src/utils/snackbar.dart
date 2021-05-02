import 'package:flutter/material.dart';

class Snackbar {
  static void showSnackbar(
      BuildContext context, GlobalKey<ScaffoldState> key, String text) {
    if (context == null) return;
    if (key == null) return;
    if (key.currentState == null) return;

    FocusScope.of(context).requestFocus(new FocusNode());

    // ignore: deprecated_member_use
    key.currentState?.removeCurrentSnackBar();
    // ignore: deprecated_member_use
    key.currentState.showSnackBar(new SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 5)));
  }
}
