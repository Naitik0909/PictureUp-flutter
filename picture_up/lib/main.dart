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
    return ChangeNotifierProvider<UserProviderData>(
      create: (_) => UserProviderData(),
      child: MaterialApp(
        title: 'PictureUp',
        home: LoginPage(),
      ),
    );
  }
}

class UserProviderData extends ChangeNotifier{
  String username;
  String roomCode;
  String roomID;
  bool isOwner;
  // No use for now -
//  String get messageCollection => 'game/' + roomID + '/messages';
//  String get roundCollection => 'game/' + roomID + '/round';
//  bool isPainter = false;

  void setUsername(String newUsername){
    username = newUsername;
    notifyListeners();
  }

  void setRoomCode(String newRoomCode){
    roomCode = newRoomCode;
    notifyListeners();
  }

  void setOwner(bool newIsOwner){
    isOwner = newIsOwner;
    notifyListeners();
  }

  void setRoomID(String newRoomId){
    roomID = newRoomId;
    notifyListeners();
  }
}
