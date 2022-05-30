import 'package:flutter/material.dart';
import 'package:guess/data.dart';
import 'package:guess/game_store.dart';
import 'package:guess/question.dart';
import 'package:share_plus/share_plus.dart';

import 'answer.dart';

class Guess extends StatefulWidget {
  final GameMode mode;

  const Guess({Key? key, required this.mode}) : super(key: key);

  @override
  State<Guess> createState() => _GuessState();
}

class _GuessState extends State<Guess> {
  late List<Question> questions;
  int _current = 0;
  bool _showAnswer = false;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    questions = GameStore.loadQuestion(widget.mode);
    questions.shuffle();
  }

  void _onNext() {
    setState(() {
      _showAnswer = !_showAnswer;
      if (!_showAnswer) {
        _current++;
        _showHint = false;
      }
    });
  }

  void _onAnswerMatch() {
    setState(() {
      _showAnswer = true;
    });
  }

  void _onShowHint() {
    setState(() {
      _showHint = !_showHint;
    });
  }

  void _onShare() {
    final question = questions[_current];
    Share.share(question.question);
  }

  @override
  Widget build(BuildContext context) {
    if (_current == questions.length) {
      final modeTxt = GameStore.gameModeText(widget.mode);

      return Scaffold(
          body: Center(
              child: Text("🎉恭喜你完成了$modeTxt.",
                  style: const TextStyle(fontSize: 50))),
          floatingActionButton: FloatingActionButton(
              tooltip: "返回主界面",
              child: const Icon(Icons.assignment_return_rounded),
              onPressed: () {
                Navigator.pop(context);
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat);
    }

    Question current = questions[_current];

    var body = _showAnswer
        ? Answer(answer: current.answer, mode: current.mode)
        : QuestionWidget(
            question: current,
            showHint: _showHint,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: Row(
            children: [
              IconButton(
                onPressed: _onShowHint,
                icon: const Icon(Icons.light),
                color: _showHint ? Colors.yellow : Colors.grey,
              ),
              const Spacer(),
              IconButton(onPressed: _onShare, icon: const Icon(Icons.share))
            ],
          )),
    );
  }
}
