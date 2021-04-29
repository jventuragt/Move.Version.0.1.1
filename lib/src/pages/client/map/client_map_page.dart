import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_app_1/src/pages/client/map/client_map_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/widgets/button_app.dart';
import 'package:provider/provider.dart';

class ClientMapPage extends StatefulWidget {
  @override
  _ClientMapPageState createState() => _ClientMapPageState();
}

class _ClientMapPageState extends State<ClientMapPage> {
  ClientMapController _con = new ClientMapController();

  //
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
                _buttonDrawer(),
                _cardGooglePlaces(),
                _buttonChangeTo(),
                _buttonCenterPosition(),
                Expanded(child: Container()),
                _buttonRequest(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          )
        ],
      ),
    );
  }

  Widget _iconMyLocation() {
    return FaIcon(
        FontAwesomeIcons.mapPin, size: 40, color: Colors.blueGrey,
    
    
   // Image.asset(
    //  "assets/img/my_location_yellow.png",
     // width: 50,
      //height: 50,
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

                CircleAvatar(
                  backgroundImage: _con.client?.image != null
                      ? NetworkImage(_con.client?.image)
                      : AssetImage("assets/img/pasajero.png"),
                  radius: 40,
                ),

                Container(
                  
                  child: Text(
                    _con.client?.username ?? "Usuario",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  
                ),
                Container(
                  child: Text(
                    _con.client?.email ?? "Email",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),

                  
                // SizedBox(
                //  height: 10,
                //),
                /* CircleAvatar(
                      backgroundImage: _con.client?.image != null
                          ? NetworkImage(_con.client?.image)
                          : AssetImage("assets/img/pasajero.png"),
                      radius: 40,
                    )*/
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
            
            title: Text("Cuentas Empresariales", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.city,
              //color: Colors.blueGrey,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.goToEditPage,
          ),

          ListTile(
            title: Text("Editar Perfil", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.edit,
            //  color: Colors.blueGrey,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.goToEditPage,
          ),
          ListTile(
            title: Text("Historia de Viajes", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.taxi,
             // color: Colors.blueGrey,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.goToHistoryPage,
          ),

            ListTile(
            title: Text("Mi Cuenta", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.userPlus,
             // color: Colors.blueGrey,
            ),
            ),

            ListTile(
            title: Text("Seguridad", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.key,
            // color: Colors.blueGrey,
            ),
            ),

            ListTile(
            title: Text("Ayuda", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.info,
             // color: Colors.blueGrey,
            ),
            ),

            ListTile(
            title: Text("Soporte", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.phone,
             // color: Colors.blueGrey,
            ),
            ),

            ListTile(
            title: Text("Promociones", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.gift,
              //color: Colors.white,
            ),
            ),

          ListTile(
            title: Text("Cerrar Sesion", style: TextStyle( fontSize: 20, 
            fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            trailing: FaIcon(
              FontAwesomeIcons.signOutAlt,
              //color: Colors.white,
            ),
            //leading: Icon(Icons.cancel),
            onTap: _con.signOut,
          ),
          ListTile(
            leading: Icon(Icons.lightbulb_outline, color: Colors.blueGrey),
            title: Text("Dark Mode"),
            trailing: Switch.adaptive(
                value: appTheme.darkTheme,
                activeColor: Colors.blueGrey,
                onChanged: (value) => appTheme.darkTheme = value),
          ),
          /*ListTile(
            leading: Icon(Icons.add_to_home_screen, color: Colors.blueGrey),
            title: Text("Custom Theme"),
            trailing: Switch.adaptive(
                value: appTheme.customTheme,
                activeColor: Colors.blueGrey,
                onChanged: (value) => appTheme.customTheme = value),
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
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  Widget _buttonChangeTo() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return GestureDetector(
      onTap: _con.changeFromTO,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Card(
          shape: CircleBorder(),
          color: appTheme.primaryColorLight,
          elevation: 8.0,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.refresh),
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

  Widget _buttonRequest() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return Container(
        height: 50,
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: ButtonApp(
            onPressed: _con.requestDriver,
            text: "SOLICITAR",
            color: appTheme.primaryColor,
            textColor: Colors.white
            )
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
      onCameraMove: (Position) {
        _con.initialPosition = Position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  Widget _cardGooglePlaces() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        color: appTheme.cardColor,
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCardLocation("Origen", _con.from ?? "Lugar de Origen",
                  () async {
                await _con.showGoogleAutoComplete(true);
              }),
              SizedBox(height: 8),
              Container(child: Divider(color: appTheme.hintColor, height: 10)),
              SizedBox(height: 8),
              _infoCardLocation(
//
                  "Destino",
                  _con.to ?? "Lugar de Destino", () async {
                await _con.showGoogleAutoComplete(false);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCardLocation(String title, String value, Function function) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return GestureDetector(
      onTap: function,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: appTheme.hintColor, fontSize: 10),
            textAlign: TextAlign.start,
          ),
          Text(
            value,
            style: TextStyle(
              color: appTheme.hintColor,
              fontSize: 15,
              //fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
