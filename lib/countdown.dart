import 'dart:async';

import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  final int second;

  const CountDown({Key? key, required this.second}) : super(key: key);

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  late Timer countdownTimer;
  late int second;

  @override
  void initState() {
    super.initState();
    second = widget.second;
    startTimer();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer.cancel());
  }

  void resetTimer(int seconds) {
    stopTimer();
    setState(() => second = widget.second);
  }

  _setCountDown() {
    setState(() {
      second--;
      if (second <= 0) {
        countdownTimer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('$second');
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
