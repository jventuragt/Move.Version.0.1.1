import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_app_1/src/pages/driver/travel_map/driver_travel_map_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/widgets/button_app.dart';
import 'package:provider/provider.dart';

class DriverTravelMapPage extends StatefulWidget {
  @override
  _DriverTravelMapPageState createState() => _DriverTravelMapPageState();
}

class _DriverTravelMapPageState extends State<DriverTravelMapPage> {
  DriverTravelMapController _con = new DriverTravelMapController();

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
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    _buttonUserInfo(),
                    Column(
                      children: [
                        _cardKmInfo(_con.km?.toStringAsFixed(1)),
                        Divider(),
                        _cardMinInfo(_con.seconds?.toString())
                      ],
                    ),

                    _buttonCenterPosition()
                  ],
                ),
                Expanded(child: Container()),
                _buttonStatus()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardMinInfo(String min) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return SafeArea(
        child: Container(
      width: 110,
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: appTheme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(
        "${min ?? ""} seg",
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
        child: Container(
      width: 110,
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(
        "${km ?? ""} km",
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget _buttonUserInfo() {
    return GestureDetector(
      onTap: _con.openBottonSheet,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: CircleBorder(),
          color: Colors.grey[300],
          elevation: 8.0,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.person, color: Colors.grey[800], size: 30),
          ),
        ),
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: CircleBorder(),
          color: Colors.grey[300],
          elevation: 8.0,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.location_searching,
                color: Colors.grey[800], size: 30),
          ),
        ),
      ),
    );
  }

  Widget _buttonStatus() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
          onPressed: _con.updateStatus,
          text: _con.currentStatus,
          color: _con.colorStatus,
          textColor: Colors.black),
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
        polylines: _con.polylines);
  }

  void refresh() {
    setState(()


    {});
  }
}
