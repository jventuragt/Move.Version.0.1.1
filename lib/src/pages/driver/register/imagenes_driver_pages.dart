import 'dart:io';

import 'package:flutter/material.dart';
import 'package:move_app_1/src/models/imagen_model.dart';
import 'package:move_app_1/src/providers/imagen_provider.dart';
//import 'package:move_app_1/src/utils/utils_imagen.dart'; as utils;
import 'package:image_picker/image_picker.dart';

class ImagenesDriverPage extends StatefulWidget {
  @override
  _ImagenesDriverPageState createState() => _ImagenesDriverPageState();
}

class _ImagenesDriverPageState extends State<ImagenesDriverPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final imagenprovider = new ImagenesProvider();

  Imagenes imagenes = new Imagenes();
  bool _guardado = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final Imagenes prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      imagenes = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Registro de Imagenes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                //_crearPrecio(),
                //_crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: imagenes.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Descripcion",
        hintText: "Describe la Imagen",
      ),
      onSaved: (value) => imagenes.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return "Ingrese el Nombre";
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      onPressed: (_guardado) ? null : _submit,
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      style: ElevatedButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 9.0,
        primary: Colors.deepPurple,
      ),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardado = true;
    });

    if (foto != null) {
      imagenes?.fotoUrl = await imagenprovider.subirImagen(foto);
    }

    if (imagenes.id == null) {
      imagenprovider.crearImagen(imagenes);
    } else {
      imagenprovider.editarProducto(imagenes);
    }

    // setState(() {_guardado = false;});
    mostrarSnackbar("Registro Guardado");

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (imagenes.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(imagenes.fotoUrl),
        placeholder: AssetImage("assets/img/jar-loading.gif"),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image(
        image: AssetImage(foto?.path ?? 'assets/img/no-image.png')
      
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: origen);
    foto = File(pickedFile.path);
    if (foto != null) {
      imagenes.fotoUrl = null;
    }
    setState(() {});
  }
}
