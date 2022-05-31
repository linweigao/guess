import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess/suggestionlist.dart';
import 'package:guess/answerList.dart';

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
  String _answer = "";
  late List<String> _answerlist;

  @override
  void initState() {
    super.initState();
    _answerlist = _getAnswerList(
        GameStore.chars, widget.question.answer.characters.toList(), 20);
  }

  List<String> _getAnswerList(
      List<String> chars, List<String> answers, int length) {
    var retVal = <String>[];
    retVal.addAll(answers.toSet());

    for (var element in chars..shuffle()) {
      if (!answers.contains(element)) {
        retVal.add(element);
      }

      if (retVal.length == length) {
        break;
      }
    }

    retVal.shuffle();
    return retVal;
  }

  _onAnswerChanged(String newAnswer) {
    setState(() {
      if (_answer.length < widget.question.answer.length) {
        // Ignore more submission
        _answer += newAnswer;
      }

      if (widget.question.answer.length == _answer.length) {
        if (widget.question.answer == _answer) {
          widget.answerMatch();
        } else {
          // Play error sound
          SystemSound.play(SystemSoundType.alert);
        }
      }
    });
  }

  _onAnswerRemoved() {
    if (_answer.isNotEmpty) {
      setState(() {
        _answer = _answer.substring(0, _answer.length - 1);
      });
    }
  }

  _onAnswerCleared() {
    setState(() {
      _answer = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 300,
        color: Colors.white70,
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              widget.question.question,
              style: Theme.of(context).textTheme.headline1,
            )),
      ),
      const SizedBox(height: 25),
      AnswerList(
        submitAnswer: _answer,
        answer: widget.question.answer,
        showHint: widget.showHint,
        onAnswerCleared: _onAnswerCleared,
        onAnswerRemoved: _onAnswerRemoved,
      ),
      const SizedBox(height: 25),
      SuggestionList(
        answers: _answerlist,
        onAnswerSubmit: _onAnswerChanged,
      )
    ]);
  }
}
