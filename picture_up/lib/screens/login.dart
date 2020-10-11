import 'package:flutter/material.dart';
import 'package:pictureup/constants.dart';
import 'package:pictureup/screens/room.dart';
import 'package:random_string/random_string.dart';
import 'dart:math';

List<String> rooms = ['ababa', 'hagsh'];

String checkRoom(String roomCode){
  int counter = 0;
  for (String room in rooms){
    if (room == roomCode){
      counter = 0;
      return checkRoom(randomAlpha(5));
    }
    else {
      counter += 1;
    }
  }
  if (counter == rooms.length){
    return roomCode;
  }
}

String generateRoom(){
  String roomCode = checkRoom(randomAlpha(5));
  return roomCode;

}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    String username;
    String userCode;

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
                onChanged: (value){
                  setState(() {
                    username = value;
                  });
                },
              ),
              TextField(
                maxLength: 5,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Room Code', labelText: 'Enter room code'),
                onChanged: (value){
                  userCode = value;
                  print(userCode);
                },
              ),
              RaisedButton(
                child: Text('Enter room'),
                onPressed: () {
                  if(username == ""){
                    showModalBottomSheet(context: context, builder: (BuildContext context) => Text('Please fill all the fields'));
                    // Improve vaildation
                  }
                  else{
                    // Check if room exists
                    for(String room in rooms){
                      if (room == userCode){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Room(roomCode: 'ababa')));
                      }
                    }

                  }
                },
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
                  String newRoomCode = generateRoom();
                  rooms.add(newRoomCode);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Room(roomCode: newRoomCode)));
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
