import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess/options_list.dart';
import 'package:guess/submit_list.dart';

import 'data.dart';
import 'game_store.dart';

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
  final List<String> _submit = [];
  late List<String> _answers;
  late List<String> _optionsList;
  late String _hideOption;
  late bool _isEnglish;

  @override
  void initState() {
    super.initState();

    _isEnglish = GameStore.isEnglishMode(widget.question.mode);
    _answers = _isEnglish
        ? widget.question.answer.split(" ").toSet().toList()
        : widget.question.answer.characters.toSet().toList();
    final wrongList = _isEnglish
        ? _getWrongList(GameStore.englishWords, _answers, 18)
        : _getWrongList(GameStore.chineseWords, _answers, 18);

    final r = Random();
    _hideOption = wrongList[r.nextInt(wrongList.length)];

    _optionsList = wrongList.toList(growable: true);
    _optionsList.addAll(_answers);
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
      if (_submit.length < widget.question.answer.length) {
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 300,
        color: Colors.white30,
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              widget.question.question,
              style: Theme.of(context).textTheme.headline1,
            )),
      ),
      const SizedBox(height: 25),
      SubmitList(
        submitAnswer: _submit,
        answer: _answers,
        onSubmitCleared: _onSubmitCleared,
        onSubmitRemoved: _onSubmitRemoved,
      ),
      const SizedBox(height: 25),
      Expanded(
          child: OptionsList(
        options: _optionsList,
        onOptionSubmit: _onSubmitTapped,
        hideOption: widget.showHint ? _hideOption : "",
      ))
    ]);
  }
}
