//import 'dart:html';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictureup/components/chat_screen.dart';
import 'package:pictureup/constants.dart';
import 'package:pictureup/screens/login.dart';
import 'package:share/share.dart';
import 'package:pictureup/components/pill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

List<Widget> players = [
  Text('Players Joined', style: kH2,),
  SizedBox(height: 20.0,),
];


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

  Future<String> getGameIDCollection(roomCode) async{
    await for(var snapshot in _firestore.collection('game').snapshots()){
      for (var roomData in snapshot.docs){
        String myCollection = 'game/'+roomData.id+'/players';
        return myCollection;
      }
    }
  }

  void getOnlinePlayers(roomCode) async{
    String myCollection = await getGameIDCollection(roomCode);
    await for(var snapshot in _firestore.collection(myCollection).snapshots()){
      for (var username in snapshot.docs){
        String user = (username.data()['username']);
        setState(() {
          players.add(Pill(color: Colors.blueGrey, icon: null, text: user,));

        });
        //Todo: Don't add if already exists in the room
      }
    }
  }

  void addMe() {
    _firestore.collection(roomCollection).add({
      'username': widget.username,
    }
    );
  }


  @override
  void initState() {
    print(widget.roomCode);
    addMe();
//    getOnlinePlayers(widget.roomCode);

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
//    players.removeRange(2, players.length);
    removeMe();
    return Future.value(true);
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
                      PlayerStream(username: widget.username, roomCode: widget.roomCode, roomID: widget.roomID,),
                  ]
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

      ),
    );
  }


}

//Todo: Convert whole code into a stream builder

class PlayerStream extends StatelessWidget {

  final String username;
  final String roomCode;
  final String roomID;

  String get roomCollection => 'game/'+roomID+'/players';

  PlayerStream({this.username, this.roomCode, this.roomID});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
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
