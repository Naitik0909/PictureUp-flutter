//import 'dart:html';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictureup/constants.dart';
import 'package:pictureup/screens/drawing.dart';
import 'package:share/share.dart';
import 'package:pictureup/components/pill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class Room extends StatefulWidget {

  final String roomCode;
  final String username;
  final bool isOwner;
  final String roomID;

  Room({@required this.roomCode, @required this.username, @required this.isOwner, this.roomID});

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {

  String get roomCollection => 'game/'+widget.roomID+'/players';

  void addMe() {
    // Todo: Owner plays first!
    _firestore.collection(roomCollection).add({
      'username': widget.username,
      'is_painter': widget.isOwner ? true : false,
      'has_guessed': false,
      'score': 0
    });
  }


  @override
  void initState() {
    print(widget.roomCode);
    addMe();
    super.initState();
  }


  Future<String> getUserID(String myCollection) async{
    await for(var snapshot in _firestore.collection(myCollection).snapshots()){
      for (var playerData in snapshot.docs){
        if(playerData.data()['username'] == widget.username){
          return playerData.id;
        }
      }
    }
  }

  void removeMe() async{
    String userID = await getUserID(roomCollection);
    _firestore.collection(roomCollection).doc(userID).delete();
  }


  Future<bool> _backPressed(){
    removeMe();
    return Future.value(true);
  }

  void startGame(){
    //Todo: Do not let users to go back at this point, show a countdowon
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DrawingPage(roomID: widget.roomID, roomCode: widget.roomCode,)));
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,  // To prevent overflowing when keyboard is triggered
        appBar: AppBar(
          title: Text('PictureUp'),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.isOwner ? 'Your room has been created!' : 'Welcome to the room', textAlign: TextAlign.center, style: kH2,),
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
                         Share.share(widget.roomCode);
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
                    children: <Widget>[
                      Text('Players Joined', style: kH2,),
                      SizedBox(height: 10.0,),
                      PlayerStream(username: widget.username, roomCode: widget.roomCode, roomID: widget.roomID,),
                  ]
                  ),
                ),
                RaisedButton(
                  onPressed: widget.isOwner ? (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DrawingPage(username: widget.username,roomID: widget.roomID, roomCode: widget.roomCode,)));} : null,
                  child: Text('START THE GAME'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.lightBlueAccent,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerStream extends StatelessWidget {

  final String username;
  final String roomCode;
  final String roomID;

  String get roomCollection => 'game/'+roomID+'/players';

  PlayerStream({this.username, this.roomCode, this.roomID});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      // Todo: Add logic for when its empty(From notes)
      stream: _firestore.collection(roomCollection).snapshots(),
      builder: (context, snapshot){
          final players = snapshot.data.docs;
          List<Widget> playersPills = [];
          for (var player in players){
            playersPills.add(Pill(color: Colors.blueGrey, icon: null, text: player.data()['username']));
          }
          return Column(
            children: playersPills,
          );
        }
    );
  }
}
