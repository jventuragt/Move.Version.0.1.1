import 'dart:convert';

Imagenes imagenesModelFromJson(String str) =>
    Imagenes.fromJson(json.decode(str));

String imagenesModelToJson(Imagenes data) => json.encode(data.toJson());

class Imagenes {
  String id;
  String titulo;
  String fotoUrl;

  Imagenes({
    this.id,
    this.titulo = "",
    this.fotoUrl,
  });

  factory Imagenes.fromJson(Map<String, dynamic> json) => Imagenes(
        id: json["id"],
        titulo: json["titulo"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        "titulo": titulo,
        "fotoUrl": fotoUrl,
      };
}
