import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:guess/boxed_text.dart';
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
      BoxedText(text: question.question, height: 150),
      const SizedBox(height: 25),
      BoxedText(text: question.answer, height: 150),
      const SizedBox(height: 50),
      Container(
          height: 400,
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: DefaultTextStyle(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .merge(const TextStyle(fontSize: 30)),
              child:
                  AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
                TypewriterAnimatedText(dialog,
                    cursor: "", speed: const Duration(milliseconds: 100)),
              ]))),
    ]);
  }
}
