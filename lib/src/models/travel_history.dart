

import 'dart:convert';

TravelHistory travelHistoryFromJson(String str) =>
    TravelHistory.fromJson(json.decode(str));

String travelHistoryToJson(TravelHistory data) => json.encode(data.toJson());

class TravelHistory {
  TravelHistory({
    this.id,
    this.idClient,
    this.idDrive,
    this.from,
    this.to,
    this.nameDriver,
    this.nameClient,
    this.timestamp,
    this.price,
    this.calificationClient,
    this.calificationDriver,
  });

  String id;
  String idClient;
  String idDrive;
  String from;
  String to;
  String nameDriver;
  String nameClient;
  int timestamp;
  double price;
  double calificationClient;
  double calificationDriver;

  factory TravelHistory.fromJson(Map<String, dynamic> json) => TravelHistory(
        id: json["id"],
        idClient: json["idClient"],
        idDrive: json["idDrive"],
        from: json["from"],
        to: json["to"],
        nameDriver: json["nameDriver"],
        nameClient: json["nameClient"],
        timestamp: json["timestamp"],
        price: json["price"]?.toDouble() ?? 0,
        calificationClient: json["calificationClient"]?.toDouble() ?? 0,
        calificationDriver: json["calificationDriver"]?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idClient": idClient,
        "idDrive": idDrive,
        "from": from,
        "to": to,
        "nameDriver": nameDriver,
        "nameClient": nameClient,
        "timestamp": timestamp,
        "price": price,
        "calificationClient": calificationClient,
        "calificationDriver": calificationDriver,
      };
}
