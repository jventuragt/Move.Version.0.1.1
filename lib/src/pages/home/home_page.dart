import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
//import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:lottie/lottie.dart';
import 'package:move_app_1/src/pages/home/home_controller.dart';
//import 'package:move_app_1/src/utils/colors.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController _con = new HomeController();

  @override
  void initState() {
    super.initState();
    // print("INT STATE");

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
    _con.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: SafeArea(
      body: Container(
        decoration: BoxDecoration(color: Colors.white10),
        child: Column(
          children: [
            _bannerApp(context),
            // SizedBox(height: 50),
             _textSelectYouRol(),
            SizedBox(height: 30),
            ElasticInLeft(child: _imagetypeUser(context, "assets/img/cond1.png", "client")),
            SizedBox(height: 10),
            FadeInDown(
              delay: Duration(milliseconds: 1000),
              child: _texttypeUser("PASAJERO")),
            SizedBox(height: 20),
            ElasticInRight(child: _imagetypeUser(context, "assets/img/map1.png", "driver")),
            SizedBox(height: 10),
            FadeInDown(
              delay: Duration(milliseconds: 1000),
              child: _texttypeUser("CONDUCTOR"))
          ],
        ),
      ),
      // ),
    );
  }

  Widget _bannerApp(BuildContext context){
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
        Positioned(top: 10.0, left: -10.0, child: FaIcon(FontAwesomeIcons.carAlt, size: 150, color: Colors.white.withOpacity(0.1))),
        //Positioned(top: 150.0, left: 10.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 100, color: Colors.white.withOpacity(0.1),)),
       // Positioned(top: 20.0, right: -20.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 150, color: Colors.white.withOpacity(0.1),)),
        //Positioned(top: 40.0, left: 150.0, child: FaIcon(FontAwesomeIcons.maxcdn, size: 50, color: Colors.white.withOpacity(0.1),)),
        Positioned(top: 10.0, left: 225.0, child: FaIcon(FontAwesomeIcons.carAlt, size: 50, color: Colors.white.withOpacity(0.1),)),
        Positioned(top: 150.0, right: 10.0, child: FaIcon(FontAwesomeIcons.carAlt, size: 100, color: Colors.white.withOpacity(0.1),)),
        Container(
         // padding: EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              JelloIn(
                     child: Image.asset(
                  ("assets/img/M_logo2.png"),

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

  Widget _textSelectYouRol() {
    return FadeInDown(
      delay: Duration(microseconds: 200),
      child: Text(
        "S E L E  C C I O N A",
        style: TextStyle(color: Colors.blue, fontSize: 30, fontFamily: "OneDay", fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _imagetypeUser(BuildContext context, String image, String typeUser) {
    return RawMaterialButton(
      elevation: 10,
      shape: CircleBorder(),
      onPressed: () => _con.goToLoginPage(typeUser),
      child: Container(decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 15,
              spreadRadius: -1,
              color: Colors.blueGrey,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: CircleAvatar(
          backgroundImage: AssetImage(image),
          radius: 50,
          // backgroundColor: Colors.blue[500],
        ),
      ),
    );
  }
  Widget _texttypeUser(String typeUser) {
    return Text(
      typeUser,
      style: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
