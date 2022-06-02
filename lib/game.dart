import 'package:flutter/material.dart';
import 'package:guess/answer.dart';
import 'package:guess/game_end.dart';
import 'package:guess/question.dart';
import 'package:share_plus/share_plus.dart';

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
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    questions = GameStore.loadQuestion(widget.mode);
    questions.shuffle();
  }

  void _onGiveUp() {
    setState(() {
      final question = questions[_current];
      GameStore.increaseErrorModeStatus(widget.mode, question);
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

  void _onShowHint() {
    setState(() {
      _showHint = true;
    });
  }

  void _onShare() {
    final question = questions[_current];
    Share.share(question.question);
  }

  Widget _buildQuestionPage(BuildContext context, Question question) {
    final title = GameStore.gameModeTitle(question.mode);

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: <Widget>[
            QuestionWidget(
              question: question,
              showHint: _showHint,
              answerMatch: _onAnswerMatch,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _onShowHint,
                    tooltip: '去掉一个错误',
                    child: const Icon(Icons.live_help, size: 30)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _onShare,
                    tooltip: '场外求助',
                    child: const Icon(Icons.ios_share, size: 30)),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 20),
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _onGiveUp,
                    tooltip: '放弃',
                    child: const Icon(Icons.navigate_next, size: 30)),
              ),
            ),
          ],
        ));
  }

  Widget _buildAnswerPage(BuildContext context, Question question) {
    final title = _answerCorrect
        ? GameStore.correctAnswerTitle()
        : GameStore.wrongAnswerTitle();

    final dialog = _answerCorrect
        ? GameStore.correctAnswerTitle()
        : GameStore.wrongAnswerTitle();

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: <Widget>[
            Answer(
              question: question,
              correct: _answerCorrect,
              defaultDialg: dialog,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _onShare,
                    tooltip: '分享成功',
                    child: const Icon(Icons.ios_share, size: 30)),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 20),
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _onNext,
                    tooltip: '下一题',
                    child: const Icon(Icons.navigate_next, size: 30)),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (_current == questions.length) {
      return GameEnd(mode: widget.mode);
    }

    Question current = questions[_current];

    if (_showAnswer) {
      return _buildAnswerPage(context, current);
    }

    return _buildQuestionPage(context, current);
  }
}
