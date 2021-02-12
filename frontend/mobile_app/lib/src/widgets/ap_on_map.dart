import 'package:flutter/material.dart';

class ApOnMap extends StatelessWidget {
  final top;
  final left;
  final cover;
  final active;
  final name;
  final piso;

  @override
  ApOnMap({this.top, this.left, this.cover, this.active, this.name, this.piso});
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (active == '0') 
                    ? Icon(Icons.check_box, color: Colors.green[900]) 
                    : Icon(Icons.warning, color: Colors.red[900]),
                Text(name,
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              ],
            )),
        height: cover,
        width: cover,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cover / 2.0),
            color: (active == '0')
                ? Color.fromRGBO(50, 150, 50, 0.4)
                : Color.fromRGBO(150, 50, 50, 0.4)),
      ),
    );
  }
}
