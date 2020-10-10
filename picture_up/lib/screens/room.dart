import 'package:flutter/material.dart';
import 'package:pictureup/constants.dart';
import 'package:share/share.dart';

class Room extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PictureUp'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your room has been created!', textAlign: TextAlign.center, style: kH2,),
              FloatingActionButton(
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
              })
            ],
          ),
        ),
      ),

    );
  }
}
