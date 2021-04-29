import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:move_app_1/src/pages/client/travel_calification/client_travel_calification_controller.dart';
import 'package:move_app_1/src/widgets/button_app.dart';

class ClientTravelCalificationPage extends StatefulWidget {
  @override
  _ClientTravelCalificationPageState createState() =>
      _ClientTravelCalificationPageState();
}

class _ClientTravelCalificationPageState
    extends State<ClientTravelCalificationPage> {
  ClientTravelCalificationController _con =
      ClientTravelCalificationController();

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
      bottomNavigationBar: _buttonCalificate(),
      body: Column(
        children: [
          //
          _bannerPriceInfo(),
          Divider(),
          _listTileTravelInfo(
              "Desde:", _con.travelHistory?.from ?? "", Icons.location_on),
          _listTileTravelInfo(
              "Hasta:", _con.travelHistory?.to ?? "", Icons.directions_subway),
          Divider(),
          _textCalificateYourDriver(),
          Divider(),
          _ratingBar(),
          Divider()
        ],
      ),
    );
  }

  Widget _buttonCalificate() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: ButtonApp(
        onPressed: _con.calificate,
        text: "CALIFICAR Y PAGAR",
        color: Colors.amber,
      ),
    );
  }

  Widget _ratingBar() {
    return Center(
      child: RatingBar.builder(
          itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
          itemCount: 5,
          initialRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          unratedColor: Colors.grey[300],
          onRatingUpdate: (rating) {
            _con.calification = rating;
            print("RATING: $rating");
          }),
    );
  }

  Widget _textCalificateYourDriver() {
    return Text(
      "CALIFICA A TU CONDUCTOR",
      style: TextStyle(
          color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _listTileTravelInfo(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 35),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          maxLines: 1,
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 2,
        ),
        leading: Icon(
          icon,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  Widget _bannerPriceInfo() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 315,
        width: double.infinity,
        color: Colors.amber,
        child: SafeArea(
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.grey[900], size: 125),
              SizedBox(height: 20),
              Text(
                "TU VIAJE HA FINALIZADO",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Valor del Viaje",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Q\ ${_con.travelHistory?.price ?? ""}",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
