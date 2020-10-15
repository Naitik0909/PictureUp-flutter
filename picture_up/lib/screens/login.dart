import 'package:flutter/material.dart';
import 'package:pictureup/constants.dart';
import 'package:pictureup/screens/room.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

final _firestore = FirebaseFirestore.instance;
List<String> rooms = []; // Todo: Don't maintain list
String userName;
String userCode;


void roomStream() async{
  await for(var snapshot in _firestore.collection('rooms').snapshots()){

    for (var roomData in snapshot.docs){
      rooms.add((roomData.data()['room_code']).toString());
    }
  }
}

void checkIfRoomExists(String userName, String roomCode, BuildContext context) async{
  await for(var snapshot in _firestore.collection('rooms').snapshots()){
    for (var roomData in snapshot.docs){
      if(roomData.data()['room_code'].toString() == roomCode){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Room(roomCode: roomCode, username: userName, isOwner: false, roomID: 'm2J1h1wX00AwW1jtR78e',)));
      }
    }
  }
}

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

    return Scaffold(
      // Todo: Implement provider package to provide and listen to username
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
                    userName = value;

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
                },
              ),
              RaisedButton(
                child: Text('Enter room'),
                onPressed: () {
                  if(userName == null){
                    showModalBottomSheet(context: context, builder: (BuildContext context) => Text('Please fill all the fields'));
                    // Improve validation
                  }
                  else{
                    // Check if room exists
                    checkIfRoomExists(userName, userCode, context);
//                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Room(roomCode: 'abcab', username: userName, isOwner: false,)));

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
                  //Todo: Validate username that has been provided
                  String newRoomCode = generateRoom();
                  // Todo: Write a new function to generate room
//                  rooms.add(newRoomCode);
//                  _firestore.collection('rooms').add({
//                    'room_code' : newRoomCode,
//                    'room_owner': userName
//                  });
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Room(roomCode: "abcab", username: userName, isOwner: true, roomID: 'm2J1h1wX00AwW1jtR78e',)));
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
