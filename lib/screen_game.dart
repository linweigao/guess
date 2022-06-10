import 'package:flutter/material.dart';
import 'package:guess/page_answer.dart';
import 'package:guess/page_game_end.dart';
import 'package:guess/page_question.dart';

import 'data.dart';
import 'game_store.dart';

class Game extends StatefulWidget {
  final GameMode mode;

  const Game({Key? key, required this.mode}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late List<Question> questions;
  int _current = 0;
  bool _showAnswer = false;
  bool _answerCorrect = false;

  @override
  void initState() {
    super.initState();
    questions = GameStore.loadQuestion(widget.mode);
    questions.shuffle();
  }

  void _onGiveUp() {
    final question = questions[_current];
    GameStore.increaseErrorModeStatus(widget.mode, question);

    if (widget.mode != GameMode.free) {
      _onNext();
      return;
    }

    setState(() {
      _showAnswer = true;
      _answerCorrect = false;
    });
  }

  void _onNext() {
    setState(() {
      _showAnswer = false;
      _answerCorrect = false;
      _current++;
    });
  }

  void _onAnswerMatch() {
    setState(() {
      final question = questions[_current];
      GameStore.increaseCorrectModeStatus(widget.mode, question);

      _showAnswer = true;
      _answerCorrect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_current == questions.length) {
      return GameEnd(mode: widget.mode);
    }

    Question current = questions[_current];

    if (_showAnswer) {
      return AnswerPage(
        key: Key(_current.toString()),
        question: current,
        correct: _answerCorrect,
        next: _onNext,
      );
    }

    return QuestionPage(
        key: Key(_current.toString()),
        question: current,
        answerMatch: _onAnswerMatch,
        giveUp: _onGiveUp);
  }
}
