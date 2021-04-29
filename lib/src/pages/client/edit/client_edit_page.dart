import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:move_app_1/src/pages/client/edit/client_edit_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/widgets/button_app.dart';
import 'package:provider/provider.dart';

class ClientEditPage extends StatefulWidget {
  @override
  _ClientEditPageState createState() => _ClientEditPageState();
}

class _ClientEditPageState extends State<ClientEditPage> {
  ClientEditController _con = new ClientEditController();

  @override
  void initState() {
    super.initState();
    print("INT STATE");

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("METODO BUID");

    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      bottomNavigationBar: JelloIn(child: _buttonRegister()),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        children: <Widget>[
          _bannerApp(),
          Divider(),
           SizedBox(height: 30.0),
          _textLogin(),
          Divider(),
           SizedBox(height: 30.0),
          _crearNombre(),
          Divider(),
           SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Widget _crearNombre() {
    return TextField(
      controller: _con.usernameController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          hintText: "Nombre",
          labelText: "nombre",
          suffixIcon: Icon(Icons.accessibility),
          icon: Icon(Icons.account_circle)),
    );
  }

  Widget _buttonRegister() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    var buttonApp = ButtonApp(
      onPressed: _con.update,
      text: "Actualizar Datos",
      color: appTheme.primaryColor,
    );
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: buttonApp,
    );
  }

  Widget _textLogin() {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return FadeInLeftBig(
          child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(
          "Editar Usuario",
          style: TextStyle(
              color: appTheme.hintColor, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
         decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
          gradient: LinearGradient(colors: <Color>[
            Color.fromRGBO(65, 60, 67, 1.0),
            Color.fromRGBO(146, 113, 159, 1.0),
          ]
          )
          ),
        height: MediaQuery.of(context).size.height * 0.35,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _con.showAlertDialog,
              child: CircleAvatar(
                backgroundImage: _con.imageFile != null
                    ? AssetImage(
                        _con.imageFile?.path ?? "assets/img/map1.png")
                    : _con.client?.image != null
                        ? NetworkImage(_con.client.image)
                        : AssetImage(
                            _con.imageFile?.path ?? "assets/img/map1.png"),
                radius: 50,
              ),
            ),
            Container(
              child: Text(
                _con.client?.email ?? "",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
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
