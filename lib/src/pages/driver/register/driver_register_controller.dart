import 'package:flutter/material.dart';
import 'package:move_app_1/src/models/drivers.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/driver_provider.dart';
import 'package:move_app_1/src/utils/my_progress_dialog.dart';
import 'package:move_app_1/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class DriverRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();
  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();

  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  ProgressDialog _progressDialog;

  Future init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, "Cargando....");
  }

  void register() async {
    String username = usernameController.text;
    String confirmpassword = confirmpasswordController.text;
    String email = emailController.text;
    String password = passwordController.text;

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();

    String plate = "$pin1$pin2$pin3-$pin4$pin5$pin6";

    print("Email: $email");
    print("Password: $password");

    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmpassword.isEmpty) {
      print("Ingresar Todos los Caracteres");
      utils.Snackbar.showSnackbar(
          context, key, "Ingresar Todos los Caracteres");
      return;
    }
    if (confirmpassword != password) {
      print("No Coincide");
      utils.Snackbar.showSnackbar(context, key, "No Coincide");
      return;
    }
    if (password.length < 6) {
      print("Minimo 6 Caracteres");
      utils.Snackbar.showSnackbar(context, key, "Minimo 6 Caracteres");
      return;
    }
    _progressDialog.show();

    try {
      bool isRegister = await _authProvider.register(email, password);

      if (isRegister) {
        Driver driver = new Driver(
            id: _authProvider.getUser().uid,
            email: _authProvider.getUser().email,
            username: username,
            password: password,
            plate: plate);

        await _driverProvider.create(driver);

        _progressDialog.hide();

        Navigator.pushNamedAndRemoveUntil(
            context, "driver/map", (route) => false);

        utils.Snackbar.showSnackbar(context, key, "Proceso Exitoso");
        print("Registro con Exito");
      } else {
        _progressDialog.hide();
        print("Contaseña Incorrecta");
        utils.Snackbar.showSnackbar(context, key, "Contaseña Incorrecta");
      }
    } catch (error) {
      _progressDialog.hide();
      print("Error: $error");
      utils.Snackbar.showSnackbar(context, key, "Error: $error");
    }
  }
}
