import 'package:flutter/material.dart';
import 'package:move_app_1/src/models/drivers.dart';
import 'package:move_app_1/src/models/travel_history.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/driver_provider.dart';
import 'package:move_app_1/src/providers/travel_history_provider.dart';

class ClientHistoryDetailController {
  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;

  TravelHistory travelHistory;

  Driver driver;

  String idTravelHistory;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _travelHistoryProvider = new TravelHistoryProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();

    idTravelHistory = ModalRoute.of(context).settings.arguments as String;

    getTravelHistoryInfo();
  }

  Future<List<TravelHistory>> getAll() async {
    return await _travelHistoryProvider
        .getByIdClient(_authProvider.getUser().uid);
  }

  void getTravelHistoryInfo() async {
    travelHistory = await _travelHistoryProvider.getById(idTravelHistory);
    getDriveInfo(travelHistory.idDrive);////////////////////////
  }

  void getDriveInfo(String idDriver) async {
    driver = await _driverProvider.getById(idDriver);
    refresh();
  }
}
