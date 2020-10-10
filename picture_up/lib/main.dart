import 'package:flutter/material.dart';
import 'screens/drawing.dart';
import 'screens/login.dart';
import 'screens/room.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PictureUp',
      routes: {
        '/': (context) => LoginPage(),
        '/room': (context) => Room(),
        '/game': (context) => DrawingPage(),
      },
      initialRoute: '/',
    );
  }
}
