import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:painter/painter.dart';
import 'draw_bar.dart';
import 'package:pictureup/components/pill.dart';
import 'package:pictureup/components/word_row.dart';
import 'package:pictureup/components/progress_bar.dart';
import 'package:pictureup/components/chat_screen.dart';


class DrawingPage extends StatefulWidget {
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
  }

  PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 3.0;
    controller.backgroundColor = Colors.lightBlueAccent;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
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
              child: Painter(_controller),
            ),
//            Icon(Icons.arrow_drop_down),
            //  ListView(
            // children: [
            Container(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width,
                  height: 140.0),
              child: Row(
                children: [
                  Expanded(flex: 2, child: ChatScreen()),
                  Expanded(flex: 1,child: PlayersPill())
                ],
              ),
            ),
            // )

            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                labelText: 'Enter Your Guess',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

