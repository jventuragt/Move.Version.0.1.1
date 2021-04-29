import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:move_app_1/src/providers/client_provider.dart';
import 'package:move_app_1/src/providers/driver_provider.dart';
import 'package:move_app_1/src/utils/shared_pref.dart';

class PushNotificationsProvider {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamController _streamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get message => _streamController.stream;

  void initPushNotifications() async {
    //---------ON LAUNCH---------------

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Map<String, dynamic> data = message.data;
        SharedPref sharedPref = new SharedPref();
        sharedPref.save("isNotification", "true");
        _streamController.sink.add(data);
      }
    });

    // -----------ON MESSAGE------------
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      Map<String, dynamic> data = message.data;
      print('Cuando estamos en primer plano');
      print('OnMessage: $data');
      _streamController.sink.add(data);
    });
    //-------------------ON RESUME---------------
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;
      print('A new onMessageOpenedApp event was published!');
      print('OnResume $data');
      _streamController.sink.add(data);
    });
  }

  void saveToken(String idUser, String typeUser) async {
    String token = await _firebaseMessaging.getToken();
    Map<String, dynamic> data = {"token": token};

    if (typeUser == "client") {
      ClientProvider clientProvider = new ClientProvider();
      clientProvider.update(data, idUser);
    } else {
      DriverProvider driverProvider = new DriverProvider();
      driverProvider.update(data, idUser);
    }
  }

  Future<void> sendMessage(
      String to, Map<String, dynamic> data, String title, String body) async {
    await http.post("https://fcm.googleapis.com/fcm/send",
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAyRu22fg:APA91bGXKahANs-zM86NueD3s5i3k3FDI4eL7lM8oB68uRp7NHP7-RAVG8jxnOuIq9WT6CIGFwVNddCLeeRRHkqSd6xtT46L0GEy-0sYciaChdW8-ag3_1AqzW--64fS9AkotBTq9UiB"
        },
        body: jsonEncode(<String, dynamic>{
          "notification": <String, dynamic>{
            "body": body,
            "title": title,
          },
          "priority": "high",
          "tt1": "4500s",
          "data": data,
          "to": to
        }));
  }

  void dispose() {
    _streamController?.onCancel;
  }
}
