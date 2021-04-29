import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:move_app_1/src/pages/client/edit/client_edit_page.dart';
import 'package:move_app_1/src/pages/client/history/client_history_page.dart';
import 'package:move_app_1/src/pages/client/history_detail/client_history_detail_page.dart';
import 'package:move_app_1/src/pages/client/map/client_map_page.dart';
import 'package:move_app_1/src/pages/client/register/Client_register_page.dart';
import 'package:move_app_1/src/pages/client/travel_calification/client_travel_calification_page.dart';
import 'package:move_app_1/src/pages/client/travel_info/client_travel_info_page.dart';
import 'package:move_app_1/src/pages/client/travel_map/client_travel_map_page.dart';
import 'package:move_app_1/src/pages/client/travel_request/client_travel_request_page.dart';
import 'package:move_app_1/src/pages/driver/edit/driver_edit_page.dart';
import 'package:move_app_1/src/pages/driver/history/driver_history_page.dart';
import 'package:move_app_1/src/pages/driver/history_detail/driver_history_detail_page.dart';
import 'package:move_app_1/src/pages/driver/map/driver_map_page.dart';
import 'package:move_app_1/src/pages/driver/register/driver_register_page.dart';
import 'package:move_app_1/src/pages/driver/travel_calification/driver_travel_calification_page.dart';
import 'package:move_app_1/src/pages/driver/travel_map/driver_travel_map_page.dart';
import 'package:move_app_1/src/pages/driver/travel_request/driver_travel_request_page.dart';
import 'package:move_app_1/src/pages/login/login_page.dart';
import 'package:move_app_1/src/pages/login/login_page2.dart';
import 'package:move_app_1/src/providers/push_notification_provider.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:provider/provider.dart';

import 'src/pages/home/home_page.dart';
import 'src/providers/push_notification_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ChangeNotifierProvider(create: (_) => ThemeChanger(2), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    PushNotificationsProvider pushNotificationsProvider =
        new PushNotificationsProvider();
    pushNotificationsProvider.initPushNotifications();

    pushNotificationsProvider.message.listen((data) {
    //  print("----------------NOTIFICACION NUEVA--------");
      //print(data);

      navigatorKey.currentState
          .pushNamed("driver/travel/request", arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Move",
      navigatorKey: navigatorKey,
      initialRoute: "home",
      theme: currentTheme,
      //fontFamily: "NimbusSans",
      //appBarTheme: AppBarTheme(elevation: 0),
      // primaryColor: Colors.black
      //),
      routes: {
        "home": (BuildContext context) => HomePage(),
         //"login": (BuildContext context) => LoginPage(),
        "login": (BuildContext context) => LoginPage2(),
        "client/register": (BuildContext context) => ClientRegisterPage(),
        "driver/register": (BuildContext context) => DriverRegisterPage(),
        "client/map": (BuildContext context) => ClientMapPage(),
        "driver/map": (BuildContext context) => DriverMapPage(),
        "client/travel/info": (BuildContext context) => ClientTravelInfoPage(),
        "client/travel/request": (BuildContext context) =>
            ClientTravelRequestPage(),
        "client/travel/map": (BuildContext context) => ClientTravelMapPage(),
        "client/travel/calification": (BuildContext context) =>
            ClientTravelCalificationPage(),
        "driver/travel/request": (BuildContext context) =>
            DriverTravelRequestPage(),
        "driver/travel/map": (BuildContext context) => DriverTravelMapPage(),
        "driver/travel/calification": (BuildContext context) =>
            DriverTravelCalificationPage(),
        "client/edit": (BuildContext context) => ClientEditPage(),
        "driver/edit": (BuildContext context) => DriverEditPage(),
        "client/history": (BuildContext context) => ClientHistoryPage(),
        "driver/history": (BuildContext context) => DriverHistoryPage(),
        "client/history/detail": (BuildContext context) =>
            ClientHistoryDetailPage(),
        "driver/history/detail": (BuildContext context) =>
            DriverHistoryDetailPage(),
      },
    );
  }
}
