import 'package:flutter/material.dart';
import 'screens/drawing.dart';

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
