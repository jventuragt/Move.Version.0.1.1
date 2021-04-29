import 'package:flutter/material.dart';
import 'package:move_app_1/src/models/client.dart';
import 'package:move_app_1/src/models/travel_history.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/client_provider.dart';
import 'package:move_app_1/src/providers/travel_history_provider.dart';

class DriverHistoryController {
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

  Future<String> getName(String idClient) async {
    ClientProvider clienProvider = new ClientProvider();
    Client client = await clienProvider.getById(idClient);
    return client.username;
  }

  Future<List<TravelHistory>> getAll() async {
    return await _travelHistoryProvider
        .getByIdDrive(_authProvider.getUser()?.uid);
  }

  void goToDetailHistory(String id) {
    Navigator.pushNamed(context, "driver/history/detail", arguments: id);
  }
}
