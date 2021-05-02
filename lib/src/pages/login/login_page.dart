import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:move_app_1/src/pages/login/login_controller.dart';
import 'package:move_app_1/src/widgets/button_app.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con = new LoginController();

  @override
  void initState() {
    super.initState();
    print("INT STATE");

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  String _nombre = "";
  String _email = "";

  @override
  Widget build(BuildContext context) {
    print("METODO BUID");

    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        children: <Widget>[
          _bannerApp(),
          Divider(),
          SizedBox(height: 30.0),
          _crearEmail(),
          Divider(),
          _crearPassword(),
          Divider(),
          SizedBox(height: 30),
          _buttonLogin(),
          Divider(),
          _textNoCuenta(),
          Divider(),
        ],
      ),
    );
  }









  Widget _textNoCuenta() {
    return GestureDetector(
      onTap: _con.goToRegisterPage,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Text(
          "No Tienes Cuenta ?",
          style: TextStyle(color: Colors.blue[200], fontSize: 15),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          onPressed: _con.login,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 9.0,
            primary: Colors.deepPurple,
          ),
        );
      },
    );

    

    /* Widget _buttonLogin() {
    var buttonApp = ButtonApp(
      onPressed: _con.login,
      text: "Login",
      color: Colors.blue[500],
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: buttonApp,
    );*/
  }

  Widget _crearEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            hintText: "Email",
            labelText: "Email",
            suffixIcon: Icon(Icons.alternate_email),
            icon: Icon(Icons.email)),
        onChanged: (valor) {
          setState(() {
            _email = valor;
          });
        },
      ),
    );
  }

  Widget _crearPassword() {
    return TextField(
      obscureText: true,
      controller: _con.passwordController,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          hintText: "Password",
          labelText: "Password",
          suffixIcon: Icon(Icons.lock_open),
          icon: Icon(Icons.lock)),
      onChanged: (valor) {
        setState(() {
          _email = valor;
        });
      },
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width * 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset(
              "assets/json/m2.json",
            ),
            Text(
              "Facil y Rapido",
              style: TextStyle(
                  fontFamily: "Pacifico",
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
