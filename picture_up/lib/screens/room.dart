import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictureup/components/chat_screen.dart';
import 'package:pictureup/constants.dart';
import 'package:share/share.dart';
import 'package:pictureup/components/pill.dart';

class Room extends StatelessWidget {

  final String roomCode;

  Room({@required this.roomCode});

  @override
  Widget build(BuildContext context) {

    print(roomCode);
    return Scaffold(
      resizeToAvoidBottomInset: false,  // To prevent overflowing when keyboard is triggered
      appBar: AppBar(
        title: Text('PictureUp'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your room has been created!', textAlign: TextAlign.center, style: kH2,),
              Container(
                width: 150.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.lightBlueAccent,

                  child: Row(
                    children: [
                      Text('Share the code'),
                      Icon(
                        Icons.share
                      ),
                    ],
                  ),
                    onPressed: (){
                       Share.share('abbt');
                }),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Column(
                  children: [
                    Text('Players Joined', style: kH2,),
                    SizedBox(height: 20.0,),
                    Pill(color: Colors.blueGrey, icon: null, text: 'Naitik',),
                    Pill(color: Colors.blueGrey, icon: null, text: 'Nalin',),
                    Pill(color: Colors.blueGrey, icon: null, text: 'Jayanth',),
                    Pill(color: Colors.blueGrey, icon: null, text: 'Ashish',),
                  ],
                ),
              ),
              RaisedButton(onPressed: (){},
                child: Text('START THE GAME'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: Colors.lightBlueAccent,
              )
            ],
          ),
        ),
      ),

    );
  }
}
