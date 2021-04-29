import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:move_app_1/src/pages/driver/history_detail/driver_history_detail_controller.dart';

class DriverHistoryDetailPage extends StatefulWidget {
  @override
  _DriverHistoryDetailPageState createState() =>
      _DriverHistoryDetailPageState();
}

class _DriverHistoryDetailPageState extends State<DriverHistoryDetailPage> {
  DriverHistoryDetailController _con = new DriverHistoryDetailController();

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
      appBar: AppBar(
        title: Text("Detalle del Historial"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerInfoDriver(),
            _listTileInfo(
                "Lugar de Origen", _con.travelHistory?.from, Icons.location_on),
            _listTileInfo(
                "Destino", _con.travelHistory?.to, Icons.location_searching),
            _listTileInfo(
                "Calificacion Pasajero",
                _con.travelHistory?.calificationClient?.toString(),
                Icons.star_border),
            _listTileInfo("Calificacion Conductor",
                _con.travelHistory?.calificationDriver?.toString(), Icons.star),
            _listTileInfo(
                "Precio del Viaje",
                "${_con.travelHistory?.price?.toString() ?? "Q.\0"}",
                Icons.monetization_on_outlined),
          ],
        ),
      ),
    );
  }

  Widget _listTileInfo(String title, String value, IconData icon) {
    return ListTile(
      title: Text(title ?? ""),
      subtitle: Text(value ?? ""),
      leading: Icon(icon),
    );
  }

  Widget _bannerInfoDriver() {
    return ClipPath(
      clipper: DiagonalPathClipperTwo(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
          gradient: LinearGradient(colors: <Color>[
            Color.fromRGBO(65, 60, 67, 1.0),
            Color.fromRGBO(146, 113, 159, 1.0),
          ]
          )
          ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: _con.client?.image != null
                  ? NetworkImage(_con.client?.image)
                  : AssetImage("assets/img/map1.png"),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(
              _con.client?.username ?? "",
              style: TextStyle(color: Colors.white, fontSize: 17),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
