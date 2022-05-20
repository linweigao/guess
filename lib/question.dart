import 'package:flutter/material.dart';

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
  });

  final Question question;

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: showAnswer
            ? Text(widget.question.question)
            : Text(widget.question.answer));
  }
}
