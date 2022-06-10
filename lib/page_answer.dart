import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:guess/boxed_text.dart';
import 'package:guess/screen_share.dart';
import 'package:share_plus/share_plus.dart';
import 'data.dart';
import 'game_store.dart';

class AnswerPage extends StatelessWidget {
  final Question question;
  final bool correct;
  final Function next;
  const AnswerPage(
      {super.key,
      required this.question,
      required this.correct,
      required this.next});

  Future _onShare(BuildContext context) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) {
      String shareTemplate = GameStore.shareQuestionTexts[
          Random().nextInt(GameStore.shareQuestionTexts.length)];
      if (correct) {
        shareTemplate = GameStore.shareCorrectAnswerTexts[
            Random().nextInt(GameStore.shareCorrectAnswerTexts.length)];
      }

      String shareText = shareTemplate
          .replaceFirst("{question}", question.question)
          .replaceFirst("{guess}", GameStore.gameModeTitle(question.mode));

      return ShareScreen(
          shareTitle: shareTemplate.replaceFirst("【{question}{guess}】", ""),
          shareText: shareText,
          question: question);
    }));
  }

  void _onNext() {
    next();
  }

  _buildBody(BuildContext context) {
    final defaultDialog =
        correct ? GameStore.correctAnswerTitle() : GameStore.wrongAnswerTitle();
    final correctText = correct ? "答对了🎉！" : "答错了❌";
    final dialog =
        "$correctText\n${question.answerDialog.isNotEmpty ? question.answerDialog : defaultDialog}";

    return Column(children: [
      BoxedText(text: question.question, height: 150),
      const SizedBox(height: 25),
      BoxedText(text: question.answer, height: 150),
      const SizedBox(height: 30),
      Container(
          height: 320,
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

  @override
  Widget build(BuildContext context) {
    final title =
        correct ? GameStore.correctAnswerTitle() : GameStore.wrongAnswerTitle();

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: <Widget>[
            _buildBody(context),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      await _onShare(context);
                    },
                    tooltip: '分享',
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
}
