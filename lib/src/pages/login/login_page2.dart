import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:lottie/lottie.dart';
import 'package:move_app_1/src/pages/login/login_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/widgets/button_app.dart';
import 'package:provider/provider.dart';
//import 'package:move_app_1/src/widgets/button_app.dart';

class LoginPage2 extends StatefulWidget {
  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  LoginController _con = new LoginController();

  @override
  void initState() {
    super.initState();

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
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(146, 113, 159, 1.0),
          title: Text(
            "Pagina Principal",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _crearFondo(context),
            _loginForm(context),
          ],
        ));
  }

  Widget _loginForm(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          SlideInLeft(
            child: Container(
              width: size.width * 0.85,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric(vertical: 30.0),
              decoration: BoxDecoration(
                  color: appTheme.cardColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0.0, 9.0),
                        spreadRadius: 4.0)
                  ]),
              child: Column(
                children: <Widget>[
                  FadeInLeftBig(
                      child: Text("Ingreso", style: TextStyle(fontSize: 20.0))),
                  //
                  SizedBox(height: 20.0),
                  _crearEmail(),
                  SizedBox(height: 30.0),
                  _crearPassword(),
                  SizedBox(height: 10.0),
                  JelloIn(child: _crearBoton()),

                  Bounce(from: 30, child: _textNoCuenta())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textNoCuenta() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return RawMaterialButton(
      onPressed: _con.goToRegisterPage,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Text(
          "No Tienes Cuenta ?",
          style: TextStyle(
              color: appTheme.primaryColorLight,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _crearEmail() {
    return GestureDetector(
      child: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          ////
          final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
          // final accentColor = appTheme.ll.accentColor;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _con.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.alternate_email, color: appTheme.primaryColor),
                hintText: "ejemplo@correo.com",
                labelText: "Correo Electronico",
              ),
              onChanged: (valor) {
                setState(() {
                  _email = valor;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _crearPassword() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            controller: _con.passwordController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: appTheme.primaryColor),
              labelText: "Contraseña",
            ),
            onChanged: (valor) {
              setState(() {
                _email = valor;
              });
            },
          ),
        );
      },
    );
  }

  Widget _crearBoton() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: ButtonApp(
          onPressed: _con.login,
          text: "INGRESAR",
          color: appTheme.primaryColor,
          textColor: Colors.white),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
          gradient: LinearGradient(colors: <Color>[
            Color.fromRGBO(65, 60, 67, 1.0),
            Color.fromRGBO(146, 113, 159, 1.0),
          ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(
            top: 10.0,
            left: -10.0,
            child: FaIcon(FontAwesomeIcons.carAlt,
                size: 150, color: Colors.white.withOpacity(0.1))),
        Positioned(
            top: 10.0,
            left: 225.0,
            child: FaIcon(
              FontAwesomeIcons.carAlt,
              size: 50,
              color: Colors.white.withOpacity(0.1),
            )),
        Positioned(
            top: 150.0,
            right: 10.0,
            child: FaIcon(
              FontAwesomeIcons.carAlt,
              size: 100,
              color: Colors.white.withOpacity(0.1),
            )),
        Container(
          // padding: EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              JelloIn(
                  child: Image.asset(("assets/img/M_logo2.png"),
                      width: 450, height: 325)),
            ],
          ),
        )
      ],
    );
  }
}
