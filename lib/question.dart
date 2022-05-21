import 'package:flutter/material.dart';

import 'countdown.dart';

class Question {
  final String question;
  final String answer;

  Question(this.question, this.answer);

  Question.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        answer = json['answer'];
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.question,
    required this.words,
  });

  final Question question;
  final String words;

  @override
  State<QuestionWidget> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    if (showAnswer) {
      return Center(child: Text(widget.question.answer));
    }

    return Stack(children: [
      Center(child: Text(widget.question.question)),
      const Positioned(
          top: 0.0,
          right: 0.0,
          child: Padding(
              padding: EdgeInsets.all(8.0), child: CountDown(second: 30))),
      Positioned(bottom: -50.0, child: Text(widget.words)),
    ]);
  }
}
