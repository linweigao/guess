import 'package:flutter/material.dart';
import 'package:guess/question.dart';
import 'package:guess/speechToText.dart';

class Guess extends StatefulWidget {
  const Guess({Key? key}) : super(key: key);

  @override
  State<Guess> createState() => _GuessState();
}

class _GuessState extends State<Guess> {
  final questions = <Question>[Question("aaa", "bbb")];
  int _current = 0;
  String _words = "";
  var _showAnswer = false;

  void _onWordsChanged(words) {
    setState(() {
      _words = words;
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
        words: _words,
      ),
      floatingActionButton: SpeechToTextWidget(
        onWordsChanged: _onWordsChanged,
      ),
    );
  }
}
