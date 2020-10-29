import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:painter/painter.dart';
import 'package:pictureup/components/alert.dart';
import 'draw_bar.dart';
import 'package:pictureup/components/pill.dart';
import 'package:pictureup/components/word_row.dart';
import 'package:pictureup/components/progress_bar.dart';
import 'package:pictureup/components/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:pictureup/main.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = FirebaseFirestore.instance;
String chatMessage;


class DrawingPage extends StatefulWidget {
  final String roomID;
  final String roomCode;
  final String username;

  String get messageCollection => 'game/' + roomID + '/messages';
  String get roundCollection => 'game/' + roomID + '/round';


  DrawingPage({this.roomID, this.roomCode, this.username});

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
//  bool _finished;
  PainterController _controller;



  @override
  void initState() {
    super.initState();
//    _finished = false;
    _controller = _newController();
//    var _pathhistory = PathHistory();
//    _pathhistory.add(Offset(50.0, 50.0));
  }

  PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 3.0;
    controller.backgroundColor = Colors.lightBlueAccent;
    return controller;
  }

  @override
  Widget build(BuildContext context) {

//    showDialog(
////      context: context,
////      builder: (BuildContext dialogContext) {
////        return MyAlertDialog(title: 'Title', content: 'Dialog content');
////      },
////    );

    Future<void> _askedToLead() async{
      await showDialog(
        context: context,
        child: SimpleDialog(
          title: const Text('Select assignment'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () { WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              }); },
              child: const Text('Treasury department'),
            ),
            SimpleDialogOption(
              onPressed: () { WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              }); },
              child: const Text('State department'),
            ),
          ],
        ),

      );

    }
    void getAlert(){
      Alert(
          context: context,
          title: "LOGIN",
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Username',
                ),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "LOGIN",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]).show();
    }

        void newRound() async{
          //Todo: Find out who is painter

          //Todo: Let the painter choose a word(Show a modal)

          //Todo: Prevent timer restart for non-painters

          // Increment round_no
          final roundNo = await _firestore.collection(widget.roundCollection).get();
          final roundId = roundNo.docs[0].id;
          final prev = roundNo.docs[0].data()['round_no'];
//          _firestore.collection(widget.roundCollection).doc(roundId).update({'round_no': prev+1});
          print("ITS A NEW ROUND!");
    }
    newRound();

    List<Widget> actions;
    actions = <Widget>[
      IconButton(
          icon: Icon(
            Icons.undo,
          ),
          tooltip: 'Undo',
          onPressed: () {
            if (_controller.isEmpty) {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Text('Nothing to undo'));
            } else {
              _controller.undo();
            }
          }),
      IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'Clear',
          onPressed: _controller.clear),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,  // To prevent overflowing when keyboard is triggered
      appBar: AppBar(
        title: const Text('PictureUp'),
        actions: actions,
        bottom: PreferredSize(
          child: DrawBar(_controller),
          preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
        ),
      ),
      body: Container(
        // previously container was rapped inside aspectratio
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            SizedBox(height: 3.0),
            ProgressBar(),
            WordRow(),
            SizedBox(
              height: 3.0,
            ),
            Container(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width, height: 350.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Painter(_controller),
            ),
//            Icon(Icons.arrow_drop_down),
            //  ListView(
            // children: [
            Container(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width, height: 140.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MessageStream(
                      roomID: widget.roomID,
                      username: widget.username,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: PlayerStream(
                      roomID: widget.roomID,
                    ),
                  ),
                ],
              ),
            ),
            // )

            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                labelText: context.read<String>(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
//                    if(chatMessage!=null){
//                      _firestore.collection(widget.messageCollection).add({
//                        'sender': widget.username,
//                        'message': chatMessage
//                      });
//                    }
                  },
                ),
              ),
              onChanged: (value){
                setState(() {
                  chatMessage = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerStream extends StatelessWidget {
  final String roomID;

  String get roomCollection => 'game/' + roomID + '/players';
  String get roundCollection => 'game/' + roomID + '/round';

  PlayerStream({this.roomID});


  @override
  Widget build(BuildContext context) {


    Future<int> getRoundNo() async{
      final getRoundDetails = await _firestore.collection(roundCollection).get();
      final roundNo = getRoundDetails.docs[0].data()['round_no'];
      return roundNo;
    }


    return StreamBuilder<QuerySnapshot>(
        // Todo: Add logic for when its empty(From notes)
        stream: _firestore.collection(roomCollection).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Pill> playersPills = [];
            final players = snapshot.data.docs;
            Color colour;
            IconData icon;
            int roundNo;

            return FutureBuilder(
              future: getRoundNo().then((value){
                roundNo = value;
                // Todo: Check if currentPainter has already painter
                int counter=0;
                for (var player in players) {
//                  player.data()['is_painter'] = counter == roundNo-1 ? true : false;
                  if(counter == roundNo-1){
                    _firestore.collection(roomCollection).doc(player.id).update({'is_painter' : true});
                  }
                  else{
                    if(player.data()['is_painter'] == true){
                      _firestore.collection(roomCollection).doc(player.id).update({'is_painter' : false});
                    }

                  }
                  if (player.data()['is_painter']) {
                    icon = Icons.create;
                    colour = Colors.blueGrey;
                  } else {
                    if (player.data()['has_guessed']) {
                      icon = Icons.check;
                      colour = Colors.green;
                    } else {
                      icon = Icons.remove;
                      colour = Colors.red;
                    }
                  }

                  String title = player.data()['username'] +
                      '\n' +
                      player.data()['score'].toString();
                  playersPills.add(Pill(color: colour, icon: icon, text: title));
                  counter+=1;
                }
                print(playersPills[0].text);
                return ListView(
                  children: playersPills,
                );
              }),
                builder: (context, AsyncSnapshot<ListView> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else {
                    return CircularProgressIndicator();
                  }
                },

            );
          }

          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        });

  }
}

class MessageStream extends StatelessWidget {
  final String roomID;
  final String username;
  String get messageCollection => 'game/' + roomID + '/messages';

  MessageStream({this.roomID, this.username});

  @override
  Widget build(BuildContext context) {
    final Radius radius = Radius.circular(10.0);
    // Todo: Add logic for when its empty
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(messageCollection).snapshots(),
        builder: (context, snapshot) {
          // Todo: Show messages in proper order
          final messages = snapshot.data.docs;
          List<Widget> messageBubbles = [];
          for (var message in messages) {
            String sender = message.data()['sender'];
            String msg = message.data()['message'];

            messageBubbles.add(
                MessageBubble(
                    radius: radius,
                    isMe: sender == username ? true : false,
                    sender: sender,
                    message: msg,
            ));
          }
          return ListView(
            reverse: true,
            children: messageBubbles,
          );
        });
  }
}
