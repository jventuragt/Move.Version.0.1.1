import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonApp extends StatelessWidget {
  Color color;
  Color textColor;
  String text;
  IconData icon;
  IconData icon2;
  Function onPressed;

  ButtonApp(
      {this.color,
      this.textColor = Colors.white,
      this.icon = FontAwesomeIcons.arrowRight,
      this.icon2 = FontAwesomeIcons.arrowLeft,
      this.onPressed,
      @required this.text});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        onPressed();
      },
      color: color,
      elevation: 20,
      textColor: textColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(text,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 50,
              //child: CircleAvatar(
                //radius: 15,
                child: Icon(icon, color: Colors.white),
                //backgroundColor: Colors.black,
              ),
            ),
          //)
        ],
      ),
      shape: StadiumBorder(),
    );
  }
}
