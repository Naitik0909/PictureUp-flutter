import 'package:flutter/material.dart';
import 'package:pictureup/constants.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Text('PictureUP!', style: kH1,),
              SizedBox(height: 20.0,),
              TextField(
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Your Name', labelText: 'Enter your name'),
              ),
              TextField(
                maxLength: 4,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Room Code', labelText: 'Enter room code'),
              ),
              RaisedButton(
                child: Text('Enter room'),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: Colors.lightBlueAccent,
              ),
              SizedBox(height: 30.0,),
              Text('OR', style: TextStyle(fontSize: 30.0),),
              SizedBox(height: 30.0,),
              Text('Don\'t have a room yet?'),
              RaisedButton(
                child: Text('Create a new room'),
                onPressed: () {
                  Navigator.pushNamed(context, '/room');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
