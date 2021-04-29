import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_app_1/src/api/environment.dart';
import 'package:move_app_1/src/models/client.dart';
import 'package:move_app_1/src/models/drivers.dart';
import 'package:move_app_1/src/models/prices.dart';
import 'package:move_app_1/src/models/travel_history.dart';
import 'package:move_app_1/src/models/travel_info.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/client_provider.dart';
import 'package:move_app_1/src/providers/driver_provider.dart';
import 'package:move_app_1/src/providers/geofire_provider.dart';
import 'package:move_app_1/src/providers/prices_provider.dart';
import 'package:move_app_1/src/providers/push_notification_provider.dart';
import 'package:move_app_1/src/providers/travel_history_provider.dart';
import 'package:move_app_1/src/providers/travel_info_provider.dart';
import 'package:move_app_1/src/utils/my_progress_dialog.dart';
import 'package:move_app_1/src/utils/snackbar.dart' as utils;
import 'package:move_app_1/src/widgets/botton_sheet_driver_info.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DriverTravelMapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(14.6262096, -90.562601), zoom: 14.0
//
          );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  GeoFireProvider _geoFireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;
  PricesProvider _pricesProvider;
  ClientProvider _clientProvider;
  TravelHistoryProvider _travelHistoryProvider;

  bool isConnect = true;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSuscription;

  Set<Polyline> polylines = {};

  // ignore: deprecated_member_use
  List<LatLng> points = new List();

  Driver driver;
  Client _client;

  String _idTravel;
  TravelInfo travelInfo;

  String currentStatus = "Iniciar Viaje";
  Color colorStatus = Colors.amber;

  double _distanceBetween;

  Timer _timer;
  int seconds = 0;
  int minuts = 0;
  double mt = 0;
  double km = 0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _idTravel = ModalRoute.of(context).settings.arguments as String;

    _geoFireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _pricesProvider = new PricesProvider();
    _clientProvider = new ClientProvider();
    _travelHistoryProvider = new TravelHistoryProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, "Conectandose...");

    markerDriver = await createMarkerImageFromAsset("assets/img/taxi_icon.png");
    fromMarker = await createMarkerImageFromAsset("assets/img/map_pin_red.png");
    toMarker = await createMarkerImageFromAsset("assets/img/map_pin_blue.png");
    checkGPS();
    getDriverInfo();
  }

  void getClientInfo() async {
    _client = await _clientProvider.getById(_idTravel);
  }

  Future<double> calculatePrice() async {
    Prices prices = await _pricesProvider.getAll();

    if (seconds < 60) seconds = 60;
    if (km == 0) km = 0.1;

    int min = seconds ~/ 60;

    print("-------MIN TOTALES---------");
    print(min.toString());

    print("-------KM TOTLES--------");
    print(km.toString());
    //////////////////////////////////////////7777

    double priceMin = min * prices.min;
    double priceKm = km * prices.km;

    double total = priceMin + priceKm;
    if (total < prices.minValue) {
      total = prices.minValue;
    }
    print("-------TOTAL--------");
    print(total.toString());

    return total;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = timer.tick;
      //minuts = seconds * 60;
      //para pasar a minutos hay que dividir o * dentro de 60 ver ejemmplo km
      refresh();
    });
  }

  void isCloseTopPickuoPosition(LatLng from, LatLng to) {
    _distanceBetween = Geolocator.distanceBetween(
        //
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude);

    print("------DISTANCIA: $_distanceBetween-----------");
  }

  void updateStatus() {
    if (travelInfo.status == "accepted") {
      startTravel();
      //
    } else if (travelInfo.status == "started") {
      finishTravel();
    }
  }

  void startTravel() async {
    if (_distanceBetween <= 100) {
      Map<String, dynamic> data = {"status": "started"};
      //
      await _travelInfoProvider.update(data, _idTravel);
      travelInfo.status = "started";
      currentStatus = "Finalizar Viaje";
      colorStatus = Colors.cyan;

      polylines = {};
      // ignore: deprecated_member_use
      points = List();
      // markers.remove(markers["from"]);
      markers.removeWhere((key, marker) => marker.markerId.value == "from");
      addSimpleMarker(
          //
          "to",
          travelInfo.toLat,
          travelInfo.toLng,
          "Destino",
          "",
          toMarker);

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);
      startTimer();
      refresh();
    } //
    else {
      utils.Snackbar.showSnackbar(
          context, key, "Debes estar cerca del cliente");
    }

    refresh();
  }

  void finishTravel() async {
    _timer?.cancel();

    double total = await calculatePrice();

    saveTravelHistory(total);
  }

  void saveTravelHistory(double price) async {
    TravelHistory travelHistory = new TravelHistory(
        from: travelInfo.from,
        to: travelInfo.to,
        idDrive: _authProvider.getUser().uid,///////////////
        idClient: _idTravel,///////////////////////
        timestamp: DateTime.now().millisecondsSinceEpoch,
        price: price);

    String id = await _travelHistoryProvider.create(travelHistory);

    Map<String, dynamic> data = {
      "status": "finished",
      "idTravelHistory": id,
      "price": price,
    };
    await _travelInfoProvider.update(data, _idTravel);
    travelInfo.status = "finished";

    Navigator.pushNamedAndRemoveUntil(
        context, "driver/travel/calification", (route) => false,
        arguments: id);
  }

  void _getTravelInfo() async {
    travelInfo = await _travelInfoProvider.getById(_idTravel);
    LatLng from = new LatLng(_position.latitude, _position.longitude);
    LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
    addSimpleMarker(
        "from", to.latitude, to.longitude, "Punto de Inicio", "", fromMarker);
    setPolylines(from, to);
    getClientInfo();
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFromLatLng = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointToLatLng = PointLatLng(to.latitude, to.longitude);

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS, pointFromLatLng, pointToLatLng);

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
        color: Colors.blue,
        points: points,
        width: 6);

    polylines.add(polyline);

    //addMarker("to", toLatLng.latitude, toLatLng.longitude, "Finalizar Aqui", "",
    //  toMarker);

    refresh();
  }

  void getDriverInfo() {
    Stream<DocumentSnapshot> driverStream =
        _driverProvider.getByIdStream(_authProvider.getUser().uid);
    _driverInfoSuscription = driverStream.listen((DocumentSnapshot document) {
      driver = Driver.fromJson(document.data());
      refresh();
    });
  }

  void dispose() {
    _timer?.cancel();
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _driverInfoSuscription?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geoFireProvider.createWorking(
        _authProvider.getUser().uid, _position.latitude, _position.longitude);

    _progressDialog.hide();
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      _getTravelInfo();
      centerPosition();
      saveLocation();

      addMarker("driver", _position.latitude, _position.longitude, "Posicion",
          "", markerDriver);

      _positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        if (travelInfo?.status == "started") {
          mt = mt +
              Geolocator.distanceBetween(
                  //
                  _position.latitude,
                  _position.longitude,
                  position.latitude,
                  position.longitude);
          km = mt / 1000;
        }

        _position = position;
        addMarker("driver", _position.latitude, _position.longitude, "Posicion",
            "", markerDriver);

        animateCameraToPosition(_position.latitude, _position.longitude);
        //
        if (travelInfo.fromLat != null && travelInfo.fromLng != null) {
          LatLng from = new LatLng(_position.latitude, _position.longitude);
          LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
          isCloseTopPickuoPosition(from, to);
        }

        saveLocation();
        refresh();
      });
//
    } catch (error) {
      print("Error LOC: $error");
    }
  }

  void openBottonSheet() {
    if (_client == null) return;
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottonSheetDriverInfo(
              imageUrl: _client?.image,
              username: _client?.username,
              email: _client?.email,
            ));
  }

  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    } else {
      utils.Snackbar.showSnackbar(context, key, "Activa tu GPS");
    }
  }

  void checkGPS() async {
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      print("GPS ACTIVADO");
      updateLocation();
    } else {
      print("GPS DESACTIVADO");
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        print("ACTIVO GPS");
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 17)));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescription =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescription;
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position.heading);

    markers[id] = marker;
  }

  void addSimpleMarker(
      //
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[id] = marker;
  }
}
