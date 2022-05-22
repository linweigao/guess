import 'package:flutter/material.dart';
import 'package:guess/question.dart';
import 'package:share_plus/share_plus.dart';

import 'AssetsUtils.dart';

class Guess extends StatefulWidget {
  const Guess({Key? key}) : super(key: key);

  @override
  State<Guess> createState() => _GuessState();
}

class _GuessState extends State<Guess> {
  bool loading = true;
  late List<Question> questions;
  int _current = 0;
  bool _showAnswer = false;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    AssetsUtils.loadQuestion().then((q) => {
          setState(() {
            questions = q;
            loading = false;
          })
        });
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
    if (loading) {
      return const Text("loading");
    }

    var body = _showAnswer
        ? Text(questions[_current].answer)
        : QuestionWidget(
            question: questions[_current],
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
