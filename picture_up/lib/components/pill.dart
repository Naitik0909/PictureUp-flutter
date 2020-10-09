import 'package:flutter/material.dart';

class PlayersPill extends StatelessWidget {

//  final Icon myIcon;
//  final String myName;
//  final Color myColor;
//
//  PlayersPill({this.myIcon, this.myColor, this.myName});

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        Pill(icon: Icons.create, color: Colors.blueGrey, text: 'Naitik\n450',),
        Pill(icon: Icons.check, color: Colors.green, text: 'Jayanth\n520',),
        Pill(icon: Icons.remove, color: Colors.red, text: 'Ashish\n850',),
        Pill(icon: Icons.remove, color: Colors.red, text: 'Nalin\n1050',),
      ],
    );
  }
}

class Pill extends StatelessWidget {

  final Color color;
  final IconData icon;
  final String text;

  Pill({this.color, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: Color(0xffbde9ff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        children: [
          CircleAvatar(radius: 20.0, child: Icon(icon),backgroundColor: color,),
          SizedBox(width: 5.0,),
          Text(text),
        ],
      ),
    );
  }
}
