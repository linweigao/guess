import 'package:flutter/material.dart';
import 'package:guess/assets_utils.dart';
import 'package:guess/game_store.dart';

import 'data.dart';
import 'dart:developer' as developer;

class Answer extends StatefulWidget {
  final String answer;
  final GameMode mode;
  const Answer({super.key, required this.answer, required this.mode});

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  void initState() {
    super.initState();
    QuestionSet set = GameStore.modeSet[widget.mode]!;
    set.answered.add(widget.answer);

    AssetsUtils.saveStrings(widget.mode, set.answered)
        .then((value) => developer.log("saved:$value"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      widget.answer,
      style: const TextStyle(fontSize: 100),
    ));
  }
}
