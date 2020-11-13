import 'package:flutter/material.dart';

class WordRow extends StatelessWidget {
  const WordRow({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          myWord,
          style: TextStyle(
            decoration: TextDecoration.underline,
            letterSpacing: 7,
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
          ),)
      ],
    );
  }
}
