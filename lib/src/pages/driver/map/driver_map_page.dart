import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_app_1/src/pages/driver/map/driver_map_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/widgets/button_app.dart';
import 'package:provider/provider.dart';

class DriverMapPage extends StatefulWidget {
  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  DriverMapController _con = new DriverMapController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      drawer: _drawer(context),
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonDrawer(),
                    _buttonCenterPosition(),
                  ],
                ),
                Expanded(child: Container()),
                _buttonConnect(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: _con.driver?.image != null
                      ? NetworkImage(_con.driver?.image)
                      : AssetImage("assets/img/profile.jpg"),
                  radius: 40,
                ),
                Container(
                  child: Text(
                    _con.driver?.username ?? "Usuario",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Container(
                  child: Text(
                    _con.driver?.email ?? "Email",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(65, 60, 67, 1.0),
                  Color.fromRGBO(146, 113, 159, 1.0),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Cuentas Empresariales",
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: Colors.red[300])),
            trailing: FaIcon(
              FontAwesomeIcons.city, color: Colors.red,
              //color: Colors.blueGrey,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.goToEditPage,
          ),
          ListTile(
            title: Text("Editar Perfil",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.edit,
              //  color: Colors.blueGrey,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.goToEditPage,
          ),
          /* ListTile(
            title: Text("Cargar Imagenes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.edit,
              //  color: Colors.blueGrey,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.goToImagenesDriverPages,
          ),*/
          ListTile(
            title: Text("Sube tus Imagenes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.images,
              //  color: Colors.blueGrey,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.goToDriverMostrarImagenes,
          ),
          ListTile(
            title: Text("Mis Viajes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.taxi,
              // color: Colors.blueGrey,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.goToHistoryPage,
          ),
          ListTile(
            title: Text("Mi Cuenta",
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: Colors.red[300])),
            trailing: FaIcon(
              FontAwesomeIcons.userPlus, color: Colors.red,
              // color: Colors.blueGrey,
            ),
          ),
          ListTile(
            title: Text("Seguridad",
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: Colors.red[300])),
            trailing: FaIcon(
              FontAwesomeIcons.key, color: Colors.red,
              // color: Colors.blueGrey,
            ),
          ),
          ListTile(
            title: Text("Ayuda",
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: Colors.red[300])),
            trailing: FaIcon(
              FontAwesomeIcons.info, color: Colors.red,
              // color: Colors.blueGrey,
            ),
          ),
          ListTile(
            title: Text("Soporte",
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: Colors.red[300])),
            trailing: FaIcon(
              FontAwesomeIcons.phone, color: Colors.red,
              // color: Colors.blueGrey,
            ),
          ),
          ListTile(
            title: Text("Promociones",
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: Colors.red[300])),
            trailing: FaIcon(
              FontAwesomeIcons.gift, color: Colors.red,
              //color: Colors.white,
            ),
          ),
          ListTile(
            title: Text("Cerrar Sesion",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.signOutAlt,
              //color: Colors.white,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.signOut,
          ),
          ListTile(
            leading: Icon(Icons.lightbulb_outline, color: Colors.blueGrey),
            title: Text("Dark Mode",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            trailing: Switch.adaptive(
                value: appTheme.darkTheme,
                activeColor: Colors.blueGrey,
                onChanged: (value) => appTheme.darkTheme = value),
          ),
          /* ListTile(
            leading: Icon(Icons.add_to_home_screen, color: Colors.blueGrey),
            title: Text("Custom Theme"),
            trailing: Switch.adaptive(
              value: appTheme.customTheme,
              activeColor: Colors.blueGrey,
              onChanged: (value) => appTheme.customTheme = value
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buttonCenterPosition() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Card(
          shape: CircleBorder(),
          color: appTheme.primaryColorLight,
          elevation: 8.0,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.location_searching),
          ),
        ),
      ),
    );
  }

  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _con.openDrawer,
        icon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buttonConnect() {
    return Container(
        height: 50,
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: ButtonApp(
            onPressed: _con.connect,
            text: _con.isConnect ? "DESCONECTARSE" : "CONECTARSE",
            color: _con.isConnect
                ? Colors.black
                : Color.fromRGBO(146, 113, 159, 1.0),
            textColor: _con.isConnect ? Colors.white : Colors.black));
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
//
    );
  }

  void refresh() {
    setState(() {});
  }
}
