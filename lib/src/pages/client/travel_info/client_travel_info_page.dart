import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_app_1/src/pages/client/travel_info/client_travel_info_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/widgets/button_app.dart';
import 'package:provider/provider.dart';

class ClientTravelInfoPage extends StatefulWidget {
  @override
  _ClientTravelInfoPageState createState() => _ClientTravelInfoPageState();
}

class _ClientTravelInfoPageState extends State<ClientTravelInfoPage> {
  ClientTravelInfoController _con = new ClientTravelInfoController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      body: Stack(
        children: [
          Align(
            child: _googleMapsWidget(),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: _cardTravelInfo(context),
            alignment: Alignment.bottomCenter,
          ),
          Align(
            child: _buttonBack(),
            alignment: Alignment.topLeft,
          ),
          Align(
            child: _cardKmInfo(_con.km),
            alignment: Alignment.topRight,
          ),
          Align(
            child: _cardMinInfo(_con.min),
            alignment: Alignment.topRight,
          )
        ],
      ),
    );
  }

  Widget _cardTravelInfo(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.38,
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Origen",
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              _con.from ?? "",
              style: TextStyle(fontSize: 13),
            ),
            leading: Icon(Icons.location_on),
          ),
          ListTile(
            title: Text(
              "Destino",
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              _con.to ?? "",
              style: TextStyle(fontSize: 13),
            ),
            leading: Icon(Icons.my_location),
          ),
          ListTile(
            title: Text(
              "Precio Viaje",
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              "Q\ ${_con.maxTotal?.toStringAsFixed(2) ?? "0.0"}",
              style: TextStyle(fontSize: 13),
              maxLines: 1,
            ),
            leading: Icon(Icons.attach_money_outlined),
          ),
          Container(
              height: 50,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: ButtonApp(
                  onPressed: _con.goToRequest,
                  text: "SOLICITAR",
                  color: appTheme.primaryColor,
                  textColor: Colors.white)),
        ],
      ),
    );
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
        child: Container(
      width: 110,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Text(km ?? "0 Km",
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
    ));
  }

  Widget _cardMinInfo(String min) {
    return SafeArea(
        child: Container(
      width: 110,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 10, top: 35),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Text(
        min ?? "0 Min",
        maxLines: 1,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ));
  }

  Widget _buttonBack() {
    return Stack(
      children: [
        Positioned(
          top: 90,
          child: FloatingActionButton(
            child: Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 75,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "client/map", (route) => false);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    setState(() {});
  }
}
