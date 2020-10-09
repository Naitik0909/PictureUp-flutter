import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
