import 'dart:convert';

import 'package:move_app_1/src/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
//
//
  void save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == null) return null;

    return json.decode(prefs?.getString(key));
  }

  // Nombre - true - false

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  get ThemeChanger async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ThemeChanger() {
      prefs.getInt("ThemeChanger");
    }
  }
}
