import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/drawing.dart';
import 'screens/login.dart';
import 'screens/room.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PictureUp',
      home: LoginPage(),
    );
  }
}

