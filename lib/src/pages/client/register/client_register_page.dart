import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_app_1/src/pages/client/register/client_register_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/widgets/button_app.dart';
//import 'package:move_app_1/src/widgets/button_app.dart';
import 'package:provider/provider.dart';

class ClientRegisterPage extends StatefulWidget {
  @override
  _ClientRegisterPageState createState() => _ClientRegisterPageState();
}

class _ClientRegisterPageState extends State<ClientRegisterPage> {
  ClientRegisterController _con = new ClientRegisterController();

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(146, 113, 159, 1.0),
          title: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Stack(
          children: <Widget>[
            // _crearFondo(context),
            _bannerApp(),
            _loginForm(context),
          ],
        ));
  }

  Widget _loginForm(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      key: _con.key,
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 200.0,
            ),
          ),
          SlideInLeft(
            child: Container(
              width: size.width * 0.85,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                  color: appTheme.cardColor,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 7.0,
                        offset: Offset(0.0, 10.0),
                        spreadRadius: 5.0)
                  ]),
              child: Column(
                children: <Widget>[
                  FadeInLeftBig(
                      child:
                          Text("Registro", style: TextStyle(fontSize: 25.0))),
                  //
                  //  _bannerApp(),
                  SizedBox(height: 20.0),
                  _username(),

                  SizedBox(height: 30.0),
                  email(),
                  SizedBox(height: 30.0),
                  _password(),
                  SizedBox(height: 30.0),
                  _confirmpassword(),
                  SizedBox(height: 30.0),

                  JelloIn(child: _buttonRegister()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*  print("METODO BUID");
   return Scaffold(
     key: _con.key,
      appBar: AppBar(
        backgroundColor: Color(0xff16202B),
        title: Text("Regresa a Login"),
      ),
      
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        children: <Widget>[
          _bannerApp(),
          
          _crearNombre(),
          Divider(),
          _crearEmail(),
          Divider(),
          _crearPassword(),
          Divider(),
          _confirmarPassword(),
          Divider(),
          _buttonRegister(),
          Divider(),
        ],
      ),
    );
  }*/

  Widget _username() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
      // final accentColor = appTheme.ll.accentColor;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: _con.usernameController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: FaIcon(FontAwesomeIcons.fileSignature,
                color: appTheme.primaryColor),
            hintText: "username",
            labelText: "username",
          ),
          onChanged: (valor) {
            setState(() {
              _nombre = valor;
            });
          },
        ),
      );
    });
  }

/*  Widget _crearNombre() {
    return TextField(
      controller: _con.usernameController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          hintText: "Nombre",
          labelText: "Nombre",
          suffixIcon: Icon(Icons.accessibility),
          icon: Icon(Icons.account_circle)),
      onChanged: (valor) {
        setState(() {
          _nombre = valor;
        });
      },
    );
  }*/

  Widget _buttonRegister() {
     final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return Container(
        height: 50,
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: ButtonApp(
            onPressed:  _con.register,
            text: "REGISTRAR",
            color: appTheme.primaryColor,
            textColor: Colors.white
            )
            );
  }

  /* Widget _buttonRegister() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    var buttonApp = ButtonApp(
      onPressed: _con.register,
      text: "Registrar",
      color: appTheme.primaryColor,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: buttonApp,
    );
  }*/

  Widget email() {
    return StreamBuilder(
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
              icon: FaIcon(FontAwesomeIcons.mailBulk,
                  color: appTheme.primaryColor),
              hintText: "ejemplo@correo.com",
              labelText: "Correo Electronico",
            ),
            onChanged: (valor) {
              setState(() {
                _email = valor;
              });
            },
            // controller: _con.emailController,
          ),
        );
      },
    );
  }

  /* Widget _crearEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
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
  }*/

  Widget _confirmpassword() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            controller: _con.confirmpasswordController,
            decoration: InputDecoration(
              icon:
                  FaIcon(FontAwesomeIcons.unlock, color: appTheme.primaryColor),
              hintText: "Confirmar Contraseña",
              labelText: "Confirmar Contrasena",
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

/*  Widget _confirmarPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: TextField(
        obscureText: true,
        controller: _con.confirmpasswordControler,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            hintText: "Confirmar Password",
            labelText: "Confirmar Password",
            suffixIcon: Icon(Icons.lock_open),
            icon: Icon(Icons.lock)),
        onChanged: (valor) {
          setState(() {
            _email = valor;
          });
        },
      ),
    );
  }*/

  Widget _password() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            controller: _con.passwordController,
            decoration: InputDecoration(
              icon: FaIcon(FontAwesomeIcons.lock, color: appTheme.primaryColor),
              hintText: "Contraseña",
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

/*  Widget _crearPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: TextField(
        obscureText: true,
        controller: _con.passwordControler,
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
      ),
    );
  }*/

  Widget _bannerApp() {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
          gradient: LinearGradient(colors: <Color>[
            Color.fromRGBO(65, 60, 67, 1.0),
            Color.fromRGBO(146, 113, 159, 1.0),
          ]
          )
          ),
    );

    final carro = Container(
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
        //Positioned(top: 150.0, left: 10.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 100, color: Colors.white.withOpacity(0.1),)),
        // Positioned(top: 20.0, right: -20.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 150, color: Colors.white.withOpacity(0.1),)),
        //Positioned(top: 40.0, left: 150.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 50, color: Colors.white.withOpacity(0.1),)),
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
          child: Stack(
            children: <Widget>[
              JelloIn(
                child: Image.asset(
                  ("assets/img/M_logo2.png"),
                  alignment: Alignment.bottomCenter,
                  // asset(
                  //"assets/json/m2.json",
                  width: 450,
                  height: 325,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

















/* Widget _bannerApp() {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.30,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
          gradient: LinearGradient(colors: <Color>[
            Color.fromRGBO(65, 60, 67, 1.0),
            Color.fromRGBO(146, 113, 159, 1.0),
          ]
          )
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _con.showAlertDialog,
            child: CircleAvatar(
              backgroundImage: _con.imageFile != null
                  ? AssetImage(_con.imageFile?.path ?? "assets/img/profile.jpg")
                  : _con.driver?.image != null
                      ? NetworkImage(_con.driver?.image)
                      : AssetImage(
                          _con.imageFile?.path ?? "assets/img/profile.jpg"),
              radius: 50,
            ),
          ),
          Container(
            child: Text(
              _con.driver?.email ?? "",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
    final carro = Container(
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
        //Positioned(top: 150.0, left: 10.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 100, color: Colors.white.withOpacity(0.1),)),
        // Positioned(top: 20.0, right: -20.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 150, color: Colors.white.withOpacity(0.1),)),
        //Positioned(top: 40.0, left: 150.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 50, color: Colors.white.withOpacity(0.1),)),
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
        /* Container(
          // padding: EdgeInsets.only(top: 10.0),
          child: Stack(
            children: <Widget>[
              JelloIn(
                child: Image.asset(
                  ("assets/img/M_logo2.png"),
                  alignment: Alignment.bottomCenter,
                  // asset(
                  //"assets/json/m2.json",
                  width: 450,
                  height: 325,
                ),
              ),
            ],
          ),
        )*/
      ],
    );
  }*/