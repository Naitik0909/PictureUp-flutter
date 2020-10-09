import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'screens/draw_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'components/pill.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PictureUp',
      home: DrawingPage(),
    );
  }
}

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  bool _finished;
  PainterController _controller;

  @override
  void initState() {
    super.initState();
    _finished = false;
    _controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.green;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width-75.0,
                  lineHeight: 20.0,
                  percent: 0.55,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
                CircleAvatar(child: Text('55'), radius: 15.0,)
              ],
            ),
            SizedBox(
              height: 3.0,
            ),
            Container(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width, height: 320.0),
              child: Painter(_controller),
            ),
            Icon(Icons.arrow_drop_down),
            //  ListView(
            // children: [
            Container(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width - 80.0,
                  height: 150.0),
              child: PlayersPill(),
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
