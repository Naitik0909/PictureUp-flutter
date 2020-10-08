import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'screens/draw_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
        title: const Text('PictureUs'),
        actions: actions,
        bottom: PreferredSize(
          child: DrawBar(_controller),
          preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
        ),
      ),
      body: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 10.0),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width,
                  lineHeight: 20.0,
                  percent: 0.1,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
                SizedBox(height: 10.0,),
                Expanded(child: Painter(_controller)),

                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    labelText: 'Enter Your Guess',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                  onPressed: (){},
                ),
                  ),
                ),
                Icon(Icons.arrow_drop_down),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5.0,
                        color: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 20.0,),
                            SizedBox(width: 5.0,),
                            Text('Naitik')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 5.0,
                        color: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 20.0,),
                            SizedBox(width: 5.0,),
                            Text('Jayanth')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}


