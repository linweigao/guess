import 'package:flutter/material.dart';
import 'package:guess/SuggestionList.dart';
import 'package:guess/answerList.dart';
import 'package:guess/charUtils.dart';

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
  final Question question;
  final Function answerMatch;
  final bool showHint;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.showHint,
    required this.answerMatch,
  });

  @override
  State<QuestionWidget> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  String _answer = "";
  late List<String> _answerlist;

  @override
  void initState() {
    super.initState();
    _answerlist =
        CharUtils.GetAnswerList(widget.question.answer.characters.toList(), 20);
  }

  _onAnswerChanged(String newAnswer) {
    setState(() {
      _answer += newAnswer;

      if (widget.question.answer == _answer) {
        widget.answerMatch();
      }
    });
  }

  _onAnswerRemoved() {
    if (_answer.isNotEmpty) {
      setState(() {
        _answer = _answer.substring(0, _answer.length - 1);
      });
    }
  }

  _onAnswerCleared() {
    setState(() {
      _answer = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Container(
          alignment: Alignment.center,
          height: 300,
          child: Text(widget.question.question,
              style: const TextStyle(fontSize: 100)),
        ),
        AnswerList(
          submitAnswer: _answer,
          answer: widget.question.answer,
          showHint: widget.showHint,
          onAnswerCleared: _onAnswerCleared,
          onAnswerRemoved: _onAnswerRemoved,
        ),
        SuggestionList(
          answers: _answerlist,
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
