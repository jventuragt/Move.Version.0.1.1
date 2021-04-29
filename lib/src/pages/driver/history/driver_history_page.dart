import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:move_app_1/src/models/travel_history.dart';
import 'package:move_app_1/src/pages/driver/history/driver_history_controller.dart';
import 'package:move_app_1/src/theme/theme.dart';
import 'package:move_app_1/src/utils/relative_time_util.dart';
import 'package:provider/provider.dart';

class DriverHistoryPage extends StatefulWidget {
  @override
  _DriverHistoryPageState createState() => _DriverHistoryPageState();
}

class _DriverHistoryPageState extends State<DriverHistoryPage> {
  DriverHistoryController _con = new DriverHistoryController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.key,
        appBar: AppBar(
          title: Text("Mis Viajes"),
        ),
        body: FutureBuilder(
            future: _con.getAll(),
            builder: (context, AsyncSnapshot<List<TravelHistory>> snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index) {
                    return JelloIn(
                          child: _cardHistoryInfo(
                        snapshot.data[index].from,
                        snapshot.data[index].to,
                        snapshot.data[index].nameClient,
                        snapshot.data[index].price?.toString(),
                        snapshot.data[index].calificationClient?.toString(),
                        RelativeTimeUtil.getRelativeTime(
                            snapshot.data[index].timestamp ?? 0),
                        snapshot.data[index].id,
                      ),
                    );
                  });
            }));
  }

  Widget _cardHistoryInfo(
    String from,
    String to,
    String name,
    String price,
    String calification,
    String timestamp,
    String idTravelHistory,
  ) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return GestureDetector(
      onTap: () {
        _con.goToDetailHistory(idTravelHistory);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          color: appTheme.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Divider(),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.drive_eta),
                SizedBox(width: 5),
                Text(
                  "Cliente: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Text(
                    name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(
                  "Recojer en: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Text(
                    from ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.location_searching),
                SizedBox(width: 5),
                Text(
                  "Destino: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Text(
                    to ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.monetization_on),
                SizedBox(width: 5),
                Text(
                  "Precio: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Text(
                    price ?? "Q. \0",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.format_list_numbered),
                SizedBox(width: 5),
                Text(
                  "Calificacion: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Text(
                    calification ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.timer),
                SizedBox(width: 5),
                Text(
                  "Hace: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Text(
                    timestamp ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
