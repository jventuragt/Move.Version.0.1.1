import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:move_app_1/src/pages/client/history_detail/client_history_detail_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:provider/provider.dart';

class ClientHistoryDetailPage extends StatefulWidget {
  @override
  _ClientHistoryDetailPageState createState() =>
      _ClientHistoryDetailPageState();
}

class _ClientHistoryDetailPageState extends State<ClientHistoryDetailPage> {
  ClientHistoryDetailController _con = new ClientHistoryDetailController();

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
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
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
              backgroundImage: _con.driver?.image != null
                  ? NetworkImage(_con.driver?.image)
                  : AssetImage("assets/img/map1.png"),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(
              _con.driver?.username ?? "",
              style: TextStyle(color: appTheme.hintColor, fontSize: 17),
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
