//import 'dart:html';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictureup/constants.dart';
import 'package:pictureup/screens/drawing.dart';
import 'package:share/share.dart';
import 'package:pictureup/components/pill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pictureup/models/players.dart';
import 'package:provider/provider.dart';
import 'package:pictureup/main.dart';

final _firestore = FirebaseFirestore.instance;

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  String get roomCollection =>
      'game/' + Provider.of<UserProviderData>(context, listen: false).roomID + '/players';

  void addMe() {
    // Todo: Owner does not play first!
    _firestore.collection(roomCollection).add({
      'username': Provider.of<UserProviderData>(context, listen: false).username,
      'is_painter': false,
      'has_guessed': false,
      'score': 0
    });
  }

  @override
  void initState() {
    print(Provider.of<UserProviderData>(context, listen: false).roomCode);
    addMe();
    super.initState();
  }

  Future<String> getUserID(String myCollection) async {
    await for (var snapshot
        in _firestore.collection(myCollection).snapshots()) {
      for (var playerData in snapshot.docs) {
        if (playerData.data()['username'] ==
            Provider.of<UserProviderData>(context, listen: false).username) {
          return playerData.id;
        }
      }
    }
  }

  void removeMe() async {
    String userID = await getUserID(roomCollection);
    _firestore.collection(roomCollection).doc(userID).delete();
  }

  Future<bool> _backPressed() {
    removeMe();
    return Future.value(true);
  }

  void startGame() {
    //Todo: Do not let users to go back at this point, show a countdowon
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DrawingPage(
                  roomID: Provider.of<UserProviderData>(context).roomID,
                  roomCode: Provider.of<UserProviderData>(context).roomCode,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // To prevent overflowing when keyboard is triggered
        appBar: AppBar(
          title: Text('PictureUp'),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Provider.of<UserProviderData>(context).isOwner
                      ? 'Your room has been created!'
                      : 'Welcome to the room',
                  textAlign: TextAlign.center,
                  style: kH2,
                ),
                Container(
                  width: 150.0,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Colors.lightBlueAccent,
                      child: Row(
                        children: [
                          Text('Share the code'),
                          Icon(Icons.share),
                        ],
                      ),
                      onPressed: () {
                        Share.share(
                            Provider.of<UserProviderData>(context).roomCode);
                      }),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0)),
                  padding:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Column(children: <Widget>[
                    Text(
                      'Players Joined',
                      style: kH2,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    PlayerStream(
                      username: Provider.of<UserProviderData>(context).username,
                      roomCode: Provider.of<UserProviderData>(context).roomCode,
                      roomID: Provider.of<UserProviderData>(context).roomID,
                    ),
                  ]),
                ),
                RaisedButton(
                  onPressed: Provider.of<UserProviderData>(context).isOwner
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DrawingPage(
                                        username: Provider.of<UserProviderData>(context).username,
                                        roomID: Provider.of<UserProviderData>(context).roomID,
                                        roomCode: Provider.of<UserProviderData>(context).roomCode,
                                      )));
                        }
                      : null,
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

  String get roomCollection => 'game/' + roomID + '/players';

  PlayerStream({this.username, this.roomCode, this.roomID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // Todo: Add logic for when its empty(From notes)
        stream: _firestore.collection(roomCollection).snapshots(),
        builder: (context, snapshot) {
          final players = snapshot.data.docs;
          List<Widget> playersPills = [];
          for (var player in players) {
            playersPills.add(Pill(
                color: Colors.blueGrey,
                icon: null,
                text: player.data()['username']));
          }
          return Column(
            children: playersPills,
          );
        });
  }
}
