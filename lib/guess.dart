import 'package:flutter/material.dart';
import 'package:guess/question.dart';

class Guess extends StatefulWidget {
  const Guess({Key? key}) : super(key: key);

  @override
  State<Guess> createState() => _GuessState();
}

class _GuessState extends State<Guess> {
  final questions = <Question>[Question("aaa", "bbb")];
  int _current = 0;
  var _showAnswer = false;

  void _onNext() {
    setState(() {
      _showAnswer = !_showAnswer;
      if (!_showAnswer) _current++;
    });
  }

  void _onAnswerMatch() {
    setState(() {
      _showAnswer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = _showAnswer
        ? Text(questions[_current].answer)
        : QuestionWidget(
            question: questions[_current],
            answerMatch: _onAnswerMatch,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Please Game'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: _onNext,
        tooltip: 'Next',
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
