import 'package:flutter/material.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/utils/shared_pref.dart';

class HomeController {
  BuildContext context;
  SharedPref _sharedPref;

  AuthProvider _authProvider;
  String _typeUser;
  String _isNotification;

  get key => null;

  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = new SharedPref();
    _authProvider = new AuthProvider();

    _typeUser = await _sharedPref.read("typeUser");
    _isNotification = await _sharedPref.read("isNotification");

    checkIfUserIsAuth();
  }

  void checkIfUserIsAuth() {
    bool isSigned = _authProvider.isSignedIn();
    if (isSigned) {
      if (_isNotification != true) {
        if (_typeUser == "client") {
          Navigator.pushNamedAndRemoveUntil(
              context, "client/map", (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, "driver/map", (route) => false);
        }
      }
    }
  }

  void goToLoginPage(String typeUser) {
    savetypeUser(typeUser);
    Navigator.pushNamed(context, "login");
  }

  void savetypeUser(String typeUser) async {
    await _sharedPref.save("typeUser", typeUser);
  }
}
