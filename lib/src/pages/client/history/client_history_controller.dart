import 'package:flutter/material.dart';
import 'package:move_app_1/src/models/drivers.dart';
import 'package:move_app_1/src/models/travel_history.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/driver_provider.dart';
import 'package:move_app_1/src/providers/travel_history_provider.dart';

class ClientHistoryController {
  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _travelHistoryProvider = new TravelHistoryProvider();
    _authProvider = new AuthProvider();

    refresh();
  }

  Future<String> getName(String idDrive) async {
    DriverProvider driverProvider = new DriverProvider();
    Driver drive = await driverProvider.getById(idDrive);
    return drive.username;
  }

  Future<List<TravelHistory>> getAll() async {
    return await _travelHistoryProvider
        .getByIdClient(_authProvider.getUser().uid);
  }

  void goToDetailHistory(String id) {
    Navigator.pushNamed(context, "client/history/detail", arguments: id);
  }
}
