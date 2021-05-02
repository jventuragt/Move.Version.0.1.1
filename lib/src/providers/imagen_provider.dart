import 'dart:convert';
//import 'dart:html';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:move_app_1/src/models/imagen_model.dart';

class ImagenesProvider {
  final String _url = "https://move-on-6ada8-default-rtdb.firebaseio.com";

  Future<bool> crearImagen( Imagenes imagen ) async {
    
    final url = '$_url/imagenes.json';

    final resp = await http.post( url, body: imagenesModelToJson(imagen) );

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }

  Future<bool> editarProducto( Imagenes imagen ) async {
    
    final url = '$_url/imagenes/${ imagen.id }.json';

    final resp = await http.put( url, body: imagenesModelToJson(imagen) );

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }



  Future<List<Imagenes>> cargarProductos() async {

    final url  = '$_url/imagenes.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<Imagenes> imagenes = new List();


    if ( decodedData == null ) return [];

    decodedData.forEach( ( id, imag ){

      final imagTemp = Imagenes.fromJson(imag);
      imagTemp.id = id;

      imagenes.add( imagTemp );

    });

    // print( productos[0].id );

    return imagenes;

  }


  Future<int> borrarProducto( String id ) async { 

    final url  = '$_url/imagenes/$id.json';
    final resp = await http.delete(url);

    print( resp.body );

    return 1;
  }


  Future<String> subirImagen( File imagen ) async {

    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/ravz2619/image/upload?upload_preset=d2cxublv");
        final mimeType = mime(imagen.path).split('/'); 

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadRequest.files.add(file);


    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salio mal');
      print( resp.body );
      return null;
    }

    final respData = json.decode(resp.body);
    print( respData);

    return respData['secure_url'];


  }


}
