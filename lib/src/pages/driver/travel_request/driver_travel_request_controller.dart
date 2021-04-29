import 'dart:async';

import 'package:flutter/material.dart';
import 'package:move_app_1/src/models/client.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/client_provider.dart';
import 'package:move_app_1/src/providers/geofire_provider.dart';
import 'package:move_app_1/src/providers/travel_info_provider.dart';
import 'package:move_app_1/src/utils/shared_pref.dart';

class DriverTravelRequestController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  Function refresh;
  SharedPref _sharedPref;

  String from;
  String to;
  String idClient;
  Client client;

  ClientProvider _clientProvider;
  TravelInfoProvider _travelInfoProvider;
  AuthProvider _authProvider;
  GeoFireProvider _geoFireProvider;

  Timer _timer;
  int seconds = 30;

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _sharedPref.save("isNotification", "false");

    _clientProvider = new ClientProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _geoFireProvider = new GeoFireProvider();

    Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    from = arguments["origin"];
    to = arguments["destination"];
    idClient = arguments["idClient"];

    getClientInfo();
    startTimer();
  }

  void dispose() {
    _timer?.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = seconds - 1;
      refresh();

      if (seconds == 0) {
        cancelTravel();
      }
    });
  }

  void acceptTravel() {
    Map<String, dynamic> data = {
      "idDriver": _authProvider.getUser().uid,
      "status": "accepted"
    };
    _timer?.cancel();

    _travelInfoProvider.update(data, idClient);
    _geoFireProvider.delete(_authProvider.getUser().uid);
    Navigator.pushNamedAndRemoveUntil(
        context, "driver/travel/map", (route) => false,
        arguments: idClient);

    //Navigator.pushReplacementNamed(context, "driver/travel/map",
    //  arguments: idClient);
  }

  void cancelTravel() {
    Map<String, dynamic> data = {"status": "no_accepted"};
    _timer?.cancel();

    _travelInfoProvider.update(data, idClient);
    Navigator.pushNamedAndRemoveUntil(context, "driver/map", (route) => false);
  }

  void getClientInfo() async {
    client = await _clientProvider.getById(idClient);
    refresh();
  }
}
