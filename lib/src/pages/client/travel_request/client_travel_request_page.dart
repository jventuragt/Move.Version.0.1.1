import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:move_app_1/src/pages/client/travel_request/client_travel_request_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/widgets/button_app.dart';
import 'package:provider/provider.dart';

class ClientTravelRequestPage extends StatefulWidget {
  @override
  _ClientTravelRequestPageState createState() =>
      _ClientTravelRequestPageState();
}

class _ClientTravelRequestPageState extends State<ClientTravelRequestPage> {
  ClientTravelRequestController _con = new ClientTravelRequestController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      body: Column(
        children: [
//
          _driverInfo(),
          _lottieAnimation(),
          _textLookingFor(),
          _textCounter(),
        ],
      ),
      bottomNavigationBar: _buttonCancel(),
    );
  }

  Widget _buttonCancel() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return Container(
        height: 50,
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: ButtonApp(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
              context, "client/map", (route) => false);
            },
            text: "CANCELAR",
            color: appTheme.primaryColor,
            textColor: Colors.white));
  }

  Widget _textCounter() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        "0",
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  Widget _lottieAnimation() {
    return Lottie.asset("assets/json/car-loading-animation.json",
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.height * 0.35,
        fit: BoxFit.fill);
  }

  Widget _textLookingFor() {
    return Container(
      child: Text(
        "Buscando Conductor",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _driverInfo() {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        color: Colors.black,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/img/M_logo2.png")),
            Container(
              child: Text(
                "Tu Conductor",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
