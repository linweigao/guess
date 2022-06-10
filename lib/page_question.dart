import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess/options_list.dart';
import 'package:guess/screen_share.dart';
import 'package:guess/submit_list.dart';
import 'package:guess/boxed_text.dart';

import 'data.dart';
import 'game_store.dart';

class QuestionPage extends StatefulWidget {
  final Question question;
  final Function answerMatch;
  final Function giveUp;

  const QuestionPage({
    super.key,
    required this.question,
    required this.answerMatch,
    required this.giveUp,
  });

  @override
  State<QuestionPage> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionPage> {
  final List<String> _submit = [];
  late List<String> _answers;
  late List<String> _optionsList;
  late String _hideOption;
  late bool _isEnglish;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();

    _isEnglish = GameStore.isEnglishMode(widget.question.mode);
    _answers = _isEnglish
        ? widget.question.answer.split(" ")
        : widget.question.answer.characters.toList();

    final uniqueAnswers = _answers.toSet().toList();
    final wrongList = _isEnglish
        ? _getWrongList(GameStore.englishWords, uniqueAnswers, 18)
        : _getWrongList(GameStore.chineseWords, uniqueAnswers, 18);

    final r = Random();
    _hideOption = wrongList[r.nextInt(wrongList.length)];

    _optionsList = wrongList.toList(growable: true);
    _optionsList.addAll(uniqueAnswers);
    _optionsList.shuffle();
  }

  List<String> _getWrongList(
      List<String> chars, List<String> answers, int length) {
    final wrongLength = length - answers.toSet().toList().length;
    var retVal = <String>[];

    for (var element in chars..shuffle()) {
      if (!answers.contains(element)) {
        retVal.add(element);
      }

      if (retVal.length == wrongLength) {
        break;
      }
    }

    return retVal;
  }

  _onSubmitTapped(String newSubmit) {
    setState(() {
      if (_submit.length < _answers.length) {
        // Ignore more submission
        _submit.add(newSubmit);
      }

      if (_answers.length == _submit.length) {
        if (const ListEquality().equals(_answers, _submit)) {
          widget.answerMatch();
        } else {
          // Play error sound
          SystemSound.play(SystemSoundType.alert);
        }
      }
    });
  }

  _onSubmitRemoved() {
    if (_submit.isNotEmpty) {
      setState(() {
        _submit.removeLast();
      });
    }
  }

  _onSubmitCleared() {
    setState(() {
      _submit.clear();
    });
  }

  void _onShowHint() {
    setState(() {
      _showHint = true;
    });
  }

  void _onGiveUp() {
    widget.giveUp();
  }

  Future _onShareHelp(BuildContext context) async {
    final question = widget.question;

    return await Navigator.push(context, MaterialPageRoute(builder: (context) {
      String shareTemplate = GameStore.shareQuestionTexts[
          Random().nextInt(GameStore.shareQuestionTexts.length)];

      String shareText = shareTemplate
          .replaceFirst("{question}", question.question)
          .replaceFirst("{guess}", GameStore.gameModeTitle(question.mode));

      return ShareScreen(
          shareTitle: shareTemplate.replaceFirst("【{question}{guess}】", ""),
          shareText: shareText,
          question: question);
    }));
  }

  _buildBody(BuildContext context, Question question) {
    return Column(children: [
      BoxedText(text: question.question, height: 300),
      const SizedBox(height: 25),
      SubmitList(
        submitAnswer: _submit,
        answer: _answers,
        onSubmitCleared: _onSubmitCleared,
        onSubmitRemoved: _onSubmitRemoved,
      ),
      const SizedBox(height: 25),
      SizedBox(
          height: 200,
          child: OptionsList(
            options: _optionsList,
            onOptionSubmit: _onSubmitTapped,
            hideOption: _showHint ? _hideOption : "",
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final title = GameStore.gameModeTitle(question.mode);

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: <Widget>[
            _buildBody(context, question),
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
                    onPressed: () async {
                      await _onShareHelp(context);
                    },
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
}
