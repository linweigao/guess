import 'dart:math';

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
  String _submit = "";
  late List<String> _optionsList;
  late String _hideOption;

  @override
  void initState() {
    super.initState();
    final wrongList = _getWrongList(
        GameStore.chars, widget.question.answer.characters.toList(), 18);

    final r = Random();
    _hideOption = wrongList[r.nextInt(wrongList.length - 1)];

    _optionsList = wrongList.toList(growable: true);
    _optionsList.addAll(widget.question.answer.characters.toSet().toList());
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

  _onSubmitChanged(String newSubmit) {
    setState(() {
      if (_submit.length < widget.question.answer.length) {
        // Ignore more submission
        _submit += newSubmit;
      }

      if (widget.question.answer.length == _submit.length) {
        if (widget.question.answer == _submit) {
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
        _submit = _submit.substring(0, _submit.length - 1);
      });
    }
  }

  _onSubmitCleared() {
    setState(() {
      _submit = "";
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
        answer: widget.question.answer,
        onSubmitCleared: _onSubmitCleared,
        onSubmitRemoved: _onSubmitRemoved,
      ),
      const SizedBox(height: 25),
      Expanded(
          child: OptionsList(
        options: _optionsList,
        onOptionSubmit: _onSubmitChanged,
        hideOption: widget.showHint ? _hideOption : "",
      ))
    ]);
  }
}
