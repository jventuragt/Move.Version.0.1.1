import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:location/location.dart' as location;
import 'package:move_app_1/src/api/environment.dart';
import 'package:move_app_1/src/models/client.dart';
import 'package:move_app_1/src/providers/auth_provider.dart';
import 'package:move_app_1/src/providers/client_provider.dart';
import 'package:move_app_1/src/providers/geofire_provider.dart';
import 'package:move_app_1/src/providers/push_notification_provider.dart';
import 'package:move_app_1/src/utils/my_progress_dialog.dart';
import 'package:move_app_1/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class ClientMapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(14.6262096, -90.562601), zoom: 17.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;

  GeoFireProvider _geoFireProvider;
  AuthProvider _authProvider;
  ClientProvider _clientProvider;
  PushNotificationsProvider _pushNotificationsProvider;

  bool isConnect = true;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _clientInfoSubscription;

  Client client;

  String from;
  LatLng fromLatLng;

  String to;
  LatLng toLatLng;

  bool isFromSelected = true;

  places.GoogleMapsPlaces _places =
      places.GoogleMapsPlaces(apiKey: Environment.API_KEY_MAPS);

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geoFireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, "Conectandose...");
    //
    markerDriver = await createMarkerImageFromAsset("assets/img/icon_taxi.png");
//
    checkGPS();
    saveToken();
    getClientInfo();
  }

  void getClientInfo() {
    Stream<DocumentSnapshot> clientrStream =
        _clientProvider.getByIdStream(_authProvider.getUser().uid);
    _clientInfoSubscription = clientrStream.listen((DocumentSnapshot document) {
      client = Client.fromJson(document.data());
      refresh();
    });
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void dispose() {
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _clientInfoSubscription?.cancel();
  }

  void signOut() async {
    await _authProvider.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
  }

  void onMapCreated(GoogleMapController controller) {
//    controller.setMapStyle("Map ID: b5d6ae2698ed9558");
    _mapController.complete(controller);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();
      getNearbyDriver();
//
    } catch (error) {}
  }

  void requestDriver() {
    if (fromLatLng != null && toLatLng != null) {
      Navigator.pushNamed(context, "client/travel/info", arguments: {
        "from": from,
        "to": to,
        "fromLatLng": fromLatLng,
        "toLatLng": toLatLng,
      });
    } else {
      utils.Snackbar.showSnackbar(context, key, "Seleccionar Origen y Destino");
    }
  }

  void changeFromTO() {
    isFromSelected = !isFromSelected;
    if (isFromSelected) {
      utils.Snackbar.showSnackbar(context, key, "Origen");
    } else {
      utils.Snackbar.showSnackbar(context, key, "Destino");
    }
  }

  Future<Null> showGoogleAutoComplete(bool isForm) async {
    places.Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Environment.API_KEY_MAPS,
      language: "es",
      strictbounds: true,
      radius: 500000,
      location: places.Location(14.6229, -90.5315),
    );

    if (p != null) {
      places.PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId, language: "es");
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      List<Address> address =
          await Geocoder.local.findAddressesFromQuery(p.description);
      if (address != null) {
        if (address.length > 0) {
          if (detail != null) {
            String direction = detail.result.name;
            String city = address[0].locality;
            String department = address[0].adminArea;

            if (isForm) {
              from = "$direction, $city, $department";
              fromLatLng = new LatLng(lat, lng);
            } else {
              to = "$direction, $city, $department";
              toLatLng = new LatLng(lat, lng);
            }

            refresh();
          }
        }
      }
    }
  }

  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

      if (address != null) {
        if (address.length > 0) {
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department = address[0].administrativeArea;
          String country = address[0].country;

          if (isFromSelected) {
            from = "$direction #$street, $city, $department";
            fromLatLng = new LatLng(lat, lng);
          } else {
            to = "$direction #$street, $city, $department";
            toLatLng = new LatLng(lat, lng);
          }

          refresh();
        }
      }
    }
  }

  void goToEditPage() {
    Navigator.pushNamed(context, "client/edit");
  }

  void goToHistoryPage() {
    Navigator.pushNamed(context, "client/history");
  }

  void saveToken() {
    _pushNotificationsProvider.saveToken(_authProvider.getUser().uid, "client");
  }

  void getNearbyDriver() {
    Stream<List<DocumentSnapshot>> stream = _geoFireProvider.getNearbyDrivers(
        _position.latitude, _position.longitude, 10);

    stream.listen((List<DocumentSnapshot> documentList) {
      for (MarkerId m in markers?.keys) {
        bool remove = true;
        refresh();
        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }

        if (remove) {
          markers.remove(m);
          refresh();
        }
      }

      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()["position"]["geopoint"];
        addMarker(d.id, point.latitude, point.longitude, "Conductor Disponible",
            d.id, markerDriver);
      }

      refresh();
    });
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
//
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
          bearing: 0,
          target: LatLng(latitude, longitude),
          zoom: 17,
          tilt: 40)));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescription =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescription;
  }

  void addMarker(
      //
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
//
      ) {
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
}
