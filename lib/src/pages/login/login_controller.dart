import 'package:flutter/material.dart';
import 'package:move_app_1/src/models/client.dart';
import 'package:move_app_1/src/models/drivers.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/client_provider.dart';
import 'package:move_app_1/src/providers/driver_provider.dart';
import 'package:move_app_1/src/utils/my_progress_dialog.dart';
import 'package:move_app_1/src/utils/shared_pref.dart';
import 'package:move_app_1/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class LoginController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordControler = new TextEditingController();

  AuthProvider _authProvider;
  ProgressDialog _progressDialog;
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;

  SharedPref _sharedPref;
  String _typeUser;

  Future init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, "Cargando....");
    _sharedPref = new SharedPref();
    _typeUser = await _sharedPref.read("typeUser");

    print("===================Tipo de Usuario===================");
    print(_typeUser);
  }

  void goToRegisterPage() {
    if (_typeUser == "client") {
      Navigator.pushNamed(context, "client/register");
    } else {
      Navigator.pushNamed(context, "driver/register");
    }
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordControler.text.trim();

    print("Email: $email");
    print("Password: $password");
    _progressDialog.show();
//
//
//
    try {
//
//
//
      bool isLogin = await _authProvider.login(email, password);
      _progressDialog.hide();

      if (isLogin) {
        print("Ingreso con Exito");
//
//
        if (_typeUser == "client") {
          Client client =
              await _clientProvider.getById(_authProvider.getUser().uid);

          print("CLIENT: $client");

          if (client != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, "client/map", (route) => false);
          } else {
            utils.Snackbar.showSnackbar(context, key, "Usuario no Valido");
            await _authProvider.signOut();
          }
        } else if (_typeUser == "driver") {
          Driver driver =
              await _driverProvider.getById(_authProvider.getUser().uid);

          print("DRIVER: $driver");

          if (driver != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, "driver/map", (route) => false);
          } else {
            utils.Snackbar.showSnackbar(context, key, "Usuario no Valido");
            await _authProvider.signOut();
          }
        }
      } else {
        utils.Snackbar.showSnackbar(context, key, "Contraseña Incorrecta");
        print("Contraseña Incorrecta");
      }
    } catch (error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, "Error: $error");
      print("Error: $error");
    }
  }
}