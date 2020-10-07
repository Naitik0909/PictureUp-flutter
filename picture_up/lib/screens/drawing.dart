import 'dart:ui';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pictureup/painting/painting.dart';
import 'package:pictureup/painting/toolkit.dart';

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  BucketFill bucketFill = BucketFill();
  bool isBucket = false;
  List<TouchPoints> points = List();
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    Widget colorMenuItem(Color color) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedColor = color;
          });
        },
        child: ClipOval(
          child: Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            height: 36,
            width: 36,
            color: color,
          ),
        ),
      );
    }

    Future<double> pickStroke() async {
      //Shows AlertDialog
      return showDialog<double>(
        context: context,

        //Dismiss alert dialog when set true
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          //Clips its child in a oval shape
          return ClipOval(
            child: AlertDialog(
              //Creates three buttons to pick stroke value.
              actions: <Widget>[
                //Resetting to default stroke value
                FlatButton(
                  child: Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    strokeWidth = 3.0;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Icon(
                    Icons.brush,
                    size: 24,
                  ),
                  onPressed: () {
                    strokeWidth = 10.0;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Icon(
                    Icons.brush,
                    size: 40,
                  ),
                  onPressed: () {
                    strokeWidth = 30.0;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Icon(
                    Icons.brush,
                    size: 60,
                  ),
                  onPressed: () {
                    strokeWidth = 50.0;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    List<Widget> fabOption() {
      return <Widget>[
        //FAB for choosing stroke
        FloatingActionButton(
          heroTag: "paint_stroke",
          child: Icon(Icons.brush),
          tooltip: 'Stroke',
          onPressed: () {
            //min: 0, max: 50
            setState(() {
              pickStroke();
            });
          },
        ),

        //FAB for resetting screen
        FloatingActionButton(
            heroTag: "erase",
            child: Icon(Icons.clear),
            tooltip: "Erase",
            onPressed: () {
              setState(() {
                points.clear();
              });
            }),
        FloatingActionButton(
          tooltip: "Paint",
          child: Icon(Icons.format_color_fill),
          onPressed: () {
            setState(() {
              isBucket = true;
            });
          },

        ),

        //FAB for picking red color
        FloatingActionButton(
          backgroundColor: Colors.white,
          heroTag: "color_red",
          child: colorMenuItem(Colors.red),
          tooltip: 'Red',
          onPressed: () {
            setState(() {
              selectedColor = Colors.red;
            });
          },
        ),

        //FAB for picking green color
        FloatingActionButton(
          backgroundColor: Colors.white,
          heroTag: "color_green",
          child: colorMenuItem(Colors.green),
          tooltip: 'Green',
          onPressed: () {
            setState(() {
              selectedColor = Colors.green;
            });
          },
        ),

        //FAB for picking pink color
        FloatingActionButton(
          backgroundColor: Colors.white,
          heroTag: "color_pink",
          child: colorMenuItem(Colors.pink),
          tooltip: 'Pink',
          onPressed: () {
            setState(() {
              selectedColor = Colors.pink;
            });
          },
        ),

        //FAB for picking blue color
        FloatingActionButton(
          backgroundColor: Colors.white,
          heroTag: "color_blue",
          child: colorMenuItem(Colors.blue),
          tooltip: 'Blue',
          onPressed: () {
            setState(() {
              selectedColor = Colors.blue;
            });
          },
        ),
        FloatingActionButton(
          backgroundColor: Colors.white,
          tooltip: 'Eraser',
          onPressed: () {
            setState(() {
              selectedColor = Colors.white;
            });
          },
        )
      ];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text('Draw Here!'),
        ),
      ),
      body: GestureDetector(
        child: CustomPaint(
          size: Size.infinite,
          painter: MyPainter(
            pointsList: points,
          ),
        ),

        onPanStart: (details) {
          setState(() {
            Offset myPoint = Offset(
                details.globalPosition.dx, details.globalPosition.dy - 90.0);
//            if (isBucket == true){
//              // bucketFill.capturePng(UniqueKey, myPoint);
//            }
//            else{

              RenderBox renderBox = context.findRenderObject();
              points.add(TouchPoints(
                  points: renderBox.globalToLocal(myPoint),
                  paint: Paint()
                    ..strokeCap = strokeType
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth));
           // }

          });
        },

        onPanUpdate: (details) {
          setState(() {
            Offset myPoint = Offset(
                details.globalPosition.dx, details.globalPosition.dy - 90.0);
            RenderBox renderBox = context.findRenderObject();
            points.add(TouchPoints(
                points: renderBox.globalToLocal(myPoint),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        colorStartAnimation: Colors.blue,
        colorEndAnimation: Colors.cyan,
        animatedIconData: AnimatedIcons.menu_close,
        fabButtons: fabOption(),
      ),
    );
  }
}
