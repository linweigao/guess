import 'package:flutter/material.dart';
import 'package:guess/answerList.dart';

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
    required this.answerMatch,
  });

  final Question question;
  final answers = const <String>["a", "b", "c", "d", "e", "f", "g", "h", "i"];
  final Function answerMatch;

  @override
  State<QuestionWidget> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  String _answer = "";

  _onAnswerChanged(String newAnswer) {
    setState(() {
      _answer += newAnswer;

      if (widget.question.answer == _answer) {
        widget.answerMatch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Text(widget.question.question),
        Text(_answer),
        AnswerList(
          answers: widget.answers,
          onAnswerSubmit: _onAnswerChanged,
        )
      ]),
      const Positioned(
          top: 0.0,
          right: 0.0,
          child: Padding(
              padding: EdgeInsets.all(8.0), child: CountDown(second: 30)))
    ]);
  }
}
