import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_app_1/src/api/environment.dart';
import 'package:move_app_1/src/models/drivers.dart';
import 'package:move_app_1/src/models/travel_info.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/driver_provider.dart';
import 'package:move_app_1/src/providers/geofire_provider.dart';
import 'package:move_app_1/src/providers/push_notification_provider.dart';
import 'package:move_app_1/src/providers/travel_info_provider.dart';
import 'package:move_app_1/src/utils/my_progress_dialog.dart';
import 'package:move_app_1/src/widgets/botton_sheet_client_info.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ClientTravelMapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(14.6262096, -90.562601), zoom: 14.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  BitmapDescriptor markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  GeoFireProvider _geoFireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;

  bool isConnect = true;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSuscription;

  Set<Polyline> polylines = {};

  // ignore: deprecated_member_use
  List<LatLng> points = new List();

  Driver driver;
  LatLng _driverLatLng;
  TravelInfo travelInfo;

  bool isRouteReady = false;

  String currentStatus = "";
  Color colorStatus = Colors.amber;

  bool isPickupTravel = false;
  bool isStartTravel = false;
  bool isFinishTravel = false;

  StreamSubscription<DocumentSnapshot> _streamLocationController;

  StreamSubscription<DocumentSnapshot> _streamTravelController;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _geoFireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, "Conectandose...");

    markerDriver = await createMarkerImageFromAsset("assets/img/icon_taxi.png");
    fromMarker = await createMarkerImageFromAsset("assets/img/map_pin_red.png");
    toMarker = await createMarkerImageFromAsset("assets/img/map_pin_blue.png");
    checkGPS();
  }

  void getDriverLocation(String idDriver) {
    Stream<DocumentSnapshot> stream =
        _geoFireProvider.getLocationByIdStream(idDriver);
    _streamLocationController = stream.listen((DocumentSnapshot document) {
      GeoPoint geoPoint = document.data()["position"]["geopoint"];
      _driverLatLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
      addSimpleMarker(
          //
          "diver",
          _driverLatLng.latitude,
          _driverLatLng.longitude,
          "Tu Conductor",
          "",
          markerDriver);

      refresh();

      if (!isRouteReady) {
        isRouteReady = true;
        CheckTravelStatus();
      }
    });
  }

  void pickupTravel() {
    if (!isPickupTravel) {
      isPickupTravel = true;
      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
      addSimpleMarker(
          "from", to.latitude, to.longitude, "Punto de Inicio", "", fromMarker);

      setPolylines(from, to);
    }
  }

  void CheckTravelStatus() async {
    Stream<DocumentSnapshot> stream =
        _travelInfoProvider.getByIdStream(_authProvider.getUser().uid);
    _streamTravelController = stream.listen((DocumentSnapshot document) {
      travelInfo = TravelInfo.fromJson(document.data());

      if (travelInfo.status == "accepted") {
        currentStatus = "Viaje Aceptado";
        colorStatus = Colors.amber;
        pickupTravel();
      } //
      else if (travelInfo.status == "started") {
        currentStatus = "Viaje Iniciado";
        colorStatus = Colors.white;
        startTravel();
      } //
      else if (travelInfo.status == "finished") {
        currentStatus = "Viaje Finalizado";
        colorStatus = Colors.cyan;
        finishTravel();
      }

      refresh();
    });
  }

  void openBottonSheet() {
    if (driver == null) return;
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottonSheetClientInfo(
              imageUrl: driver?.image,
              username: driver?.username,
              email: driver?.email,
              plate: driver?.plate,
            ));
  }

  void finishTravel() {
    if (!isFinishTravel) {
      isFinishTravel = true;
      Navigator.pushNamedAndRemoveUntil(
          context, "client/travel/calification", (route) => false,
          arguments: travelInfo.idTravelHistory);
    }
  }

  void startTravel() {
    if (!isStartTravel) {
      isStartTravel = true;
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

      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);
      refresh();
    }
  }

  void _getTravelInfo() async {
    travelInfo = await _travelInfoProvider.getById(_authProvider.getUser().uid);
    animateCameraToPosition(travelInfo.fromLat, travelInfo.fromLng);
    getDriverInfo(travelInfo.idDriver);
    getDriverLocation(travelInfo.idDriver);
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

  void getDriverInfo(String id) async {
    driver = await _driverProvider.getById(id);
    refresh();
  }

  void dispose() {
    _statusSuscription?.cancel();
    _driverInfoSuscription?.cancel();
    _streamLocationController?.cancel();
    _streamTravelController?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    _getTravelInfo();
  }

  void checkGPS() async {
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      print("GPS ACTIVADO");
    } else {
      print("GPS DESACTIVADO");
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        print("ACTIVO GPS");
      }
    }
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
