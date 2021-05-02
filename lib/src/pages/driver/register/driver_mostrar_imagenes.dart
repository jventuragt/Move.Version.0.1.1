import 'package:flutter/material.dart';
//import 'package:formvalidation/src/bloc/provider.dart';
import 'package:move_app_1/src/models/imagen_model.dart';
import 'package:move_app_1/src/providers/imagen_provider.dart';

class DriverMostrarImagenes extends StatelessWidget {
  final imagenesProvider = new ImagenesProvider();

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Regresar')),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: imagenesProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<Imagenes>> snapshot) {
        if (snapshot.hasData) {
          final imagenes = snapshot.data;

          return ListView.builder(
            itemCount: imagenes.length,
            itemBuilder: (context, i) => _crearItem(context, imagenes[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, Imagenes imagenes) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          imagenesProvider.borrarProducto(imagenes.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (imagenes.fotoUrl == null)
                  ? Image(image: AssetImage('assets/img/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(imagenes.fotoUrl),
                      placeholder: AssetImage('assets/img/jar-loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${imagenes.titulo}'),
                subtitle: Text(imagenes.id),
                onTap: () => Navigator.pushNamed(context, 'imagenes',
                    arguments: imagenes),
              ),
            ],
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'imagenes/driver'),
    );
  }
}
