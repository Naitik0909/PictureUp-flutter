import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';


class ProgressBar extends StatefulWidget {

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {

  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            _start = 60;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width-75.0,
          lineHeight: 20.0,
          percent: _start/60,
          backgroundColor: Colors.grey,
          progressColor: Colors.blue,
        ),
        CircleAvatar(child: Text("$_start"), radius: 15.0,)
      ],
    );
  }
}
