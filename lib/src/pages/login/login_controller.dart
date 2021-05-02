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
  TextEditingController passwordController = new TextEditingController();

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
    String password = passwordController.text.trim();

    print("Email: $email");
    print("Password: $password");
   

    if (email.isEmpty && password.isEmpty) {
     
      print("Ingresar Todos los Caracteres");
      utils.Snackbar.showSnackbar(
          context, key, "Ingresar Todos los Caracteres");

      return;
    }
//
    
//
    try {
//
     
//
      bool isLogin = await _authProvider.login(email, password);
      
        _progressDialog.show();
      if (isLogin) {
        print("Ingreso con Exito");
        utils.Snackbar.showSnackbar(context, key, "Login con Exito");

          
        /////////////////CLIENTE/////////////////////////////7
        if (_typeUser == "client") {
          Client client =
              await _clientProvider.getById(_authProvider.getUser().uid);
          _progressDialog.hide();

          print("CLIENT: $client");

          if (client != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, "client/map", (route) => false);
            _progressDialog.hide();
          } else {
            utils.Snackbar.showSnackbar(context, key, "Usuario no Valido");

            await _authProvider.signOut();
            _progressDialog.hide();
            return;
          }
          ////////////////CONDUCTOR//////////////////////
        } else if (_typeUser == "driver") {
          Driver driver =
              await _driverProvider.getById(_authProvider.getUser().uid);
          _progressDialog.hide();

          print("DRIVER: $driver");

          if (driver != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, "driver/map", (route) => false);
            _progressDialog.hide();
          } else {
            utils.Snackbar.showSnackbar(context, key, "Usuario no Valido");
            await _authProvider.signOut();
            _progressDialog.hide();
            return;
          }
        }
        //////////////////////PASSWORD////////////////////////7
      } else {
        utils.Snackbar.showSnackbar(context, key, "Contraseña Incorrecta");
        print("Contraseña Incorrecta");
        _progressDialog.hide();
      }
    } catch (error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, "Error: $error");
      _progressDialog.hide();
      print("Error: $error");
    }
  }
}
