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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please Game'),
      ),
      body: QuestionWidget(
        question: questions[_current],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onNext,
        tooltip: 'Next',
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
