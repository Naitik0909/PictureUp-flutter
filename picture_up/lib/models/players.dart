import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pictureup/main.dart';
import 'package:provider/provider.dart';

final _firestore = FirebaseFirestore.instance;

class PlayersData{
  Queue playersList = Queue();
  String roundCollection;

  Future<int> getRoundNo(BuildContext context) async{
    final getRoundDetails = await _firestore.collection(roundCollection).get();
    final roundNo = getRoundDetails.docs[0].data()['round_no'];
    return roundNo;
  }






}