import 'package:flutter/material.dart';

class BottonSheetClientInfo extends StatefulWidget {
  //
  String imageUrl;
  String username;
  String email;
  String plate;

  BottonSheetClientInfo({
    @required this.imageUrl,
    @required this.username,
    @required this.email,
    @required this.plate,
  });

  @override
  _BottonSheetClientInfoState createState() => _BottonSheetClientInfoState();
}

class _BottonSheetClientInfoState extends State<BottonSheetClientInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      margin: EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            "Tu Conductor",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 15),
          CircleAvatar(
            backgroundImage: widget.imageUrl != null
                ? NetworkImage(widget.imageUrl)
                : AssetImage("assets/img/profile.jpg"),
            radius: 50,
          ),
          ListTile(
            title: Text(
              "Nombre",
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.username ?? "",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
              "Correo",
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.email ?? "",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text(
              "Placa Vehiculo",
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.plate ?? "",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.directions_car_outlined),
          ),
        ],
      ),
    );
  }
}
