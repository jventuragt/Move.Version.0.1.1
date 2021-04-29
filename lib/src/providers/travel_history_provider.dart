import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_app_1/src/models/client.dart';
import 'package:move_app_1/src/models/drivers.dart';
import 'package:move_app_1/src/models/travel_history.dart';
import 'package:move_app_1/src/providers/client_provider.dart';
import 'package:move_app_1/src/providers/driver_provider.dart';

class TravelHistoryProvider {
  CollectionReference _ref;

  TravelHistoryProvider() {
    _ref = FirebaseFirestore.instance.collection("TravelHistory");
  }

  Future<String> create(TravelHistory travelHistory) async {
    String errorMessage;

    try {
      String id = _ref.doc().id;
      travelHistory.id = id;

      await _ref.doc(travelHistory.id).set(travelHistory.toJson());
      return id;
    } catch (error) {
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<List<TravelHistory>> getByIdClient(String idClient) async {
    QuerySnapshot querySnapshot = await _ref
        .where("idClient", isEqualTo: idClient)
        .orderBy("timestamp", descending: true)
        .get();
    List<Map<String, dynamic>> allData =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    // ignore: deprecated_member_use
    List<TravelHistory> travelHistoryList = new List();

    for (Map<String, dynamic> data in allData) {
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    for (TravelHistory travelHistory in travelHistoryList) {
      DriverProvider driverProvider = new DriverProvider();
      Driver drive = await driverProvider
          .getById(travelHistory.idDrive); /////////////////////////
      travelHistory.nameDriver = drive.username;
    }
    return travelHistoryList;
  }

  Future<List<TravelHistory>> getByIdDrive(String idDrive) async {
    QuerySnapshot querySnapshot = await _ref
        .where("idDrive", isEqualTo: idDrive)
        .orderBy("timestamp", descending: true)
        .get();
    List<Map<String, dynamic>> allData =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    // ignore: deprecated_member_use
    List<TravelHistory> travelHistoryList = new List();

    for (Map<String, dynamic> data in allData) {
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    for (TravelHistory travelHistory in travelHistoryList) {
      ClientProvider clientProvider = new ClientProvider();
      Client client = await clientProvider
          .getById(travelHistory.idClient); ///////////////////
      travelHistory.nameClient = client.username;
    }

    return travelHistoryList;
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<TravelHistory> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      TravelHistory client = TravelHistory.fromJson(document.data());
      return client;
    }
    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }
}
