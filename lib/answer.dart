import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class Answer extends StatefulWidget {
  final Question question;
  final bool correct;
  const Answer({super.key, required this.question, required this.correct});

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 200,
        color: Colors.white30,
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              widget.question.question,
              style: Theme.of(context).textTheme.headline1,
            )),
      ),
      const SizedBox(height: 25),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 200,
        color: Colors.white30,
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              widget.question.answer,
              style: Theme.of(context).textTheme.headline1,
            )),
      ),
      widget.question.answerDialog.isNotEmpty
          ? Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 30.0,
                          ),
                          child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                    widget.question.answerDialog,
                                    cursor: "",
                                    speed: const Duration(milliseconds: 100)),
                              ])))))
          : Container(),
      const SizedBox(height: 100),
    ]);
  }
}
