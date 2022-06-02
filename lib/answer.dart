import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class Answer extends StatelessWidget {
  final Question question;
  final bool correct;
  final String defaultDialg;
  const Answer(
      {super.key,
      required this.question,
      required this.correct,
      required this.defaultDialg});

  @override
  Widget build(BuildContext context) {
    final correctText = correct ? "答对了🎉！" : "答错了❌";
    final dialog =
        "$correctText\n${question.answerDialog.isNotEmpty ? question.answerDialog : defaultDialg}";

    return Column(children: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 150,
        color: Colors.white30,
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              question.question,
              style: Theme.of(context).textTheme.headline1,
            )),
      ),
      const SizedBox(height: 25),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 150,
        color: Colors.white30,
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              question.answer,
              style: Theme.of(context).textTheme.headline1,
            )),
      ),
      Expanded(
          child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .merge(const TextStyle(fontSize: 30)),
                      child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TypewriterAnimatedText(dialog,
                                cursor: "",
                                speed: const Duration(milliseconds: 100)),
                          ]))))),
      const SizedBox(height: 50),
    ]);
  }
}
