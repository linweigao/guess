import 'package:flutter/material.dart';
import 'data.dart';

class Answer extends StatefulWidget {
  final String answer;
  final GameMode mode;
  const Answer({super.key, required this.answer, required this.mode});

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      widget.answer,
      style: const TextStyle(fontSize: 100),
    ));
  }
}
