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
        Container(
          width: 150.0,
          child: Card(
            elevation: 5.0,
            color: Color(0xffbde9ff),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              children: [
                CircleAvatar(radius: 20.0, child: Icon(Icons.create),backgroundColor: Colors.blueGrey,),
                SizedBox(width: 5.0,),
                Text('Naitik')
              ],
            ),
          ),
        ),
        Card(
          elevation: 5.0,
          color: Color(0xffbde9ff),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            children: [
              CircleAvatar(radius: 20.0, child: Icon(Icons.check),backgroundColor: Colors.green,),
              SizedBox(width: 5.0,),
              Text('Jayanth')
            ],
          ),
        ),
        Card(
          elevation: 5.0,
          color: Color(0xffbde9ff),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            children: [
              CircleAvatar(radius: 20.0, child: Icon(Icons.remove),backgroundColor: Colors.red,),
              SizedBox(width: 5.0,),
              Text('Ashish')
            ],
          ),
        ),
        Card(
          elevation: 5.0,
          color: Color(0xffbde9ff),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            children: [
              CircleAvatar(radius: 20.0, child: Icon(Icons.remove),backgroundColor: Colors.red,),
              SizedBox(width: 5.0,),
              Text('Nalin')
            ],
          ),
        ),
      ],
    );
  }
}


