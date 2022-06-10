import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'game_store.dart';

class GameEnd extends StatelessWidget {
  final GameMode mode;
  const GameEnd({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final modeText = GameStore.gameModeText(mode);
    final set = GameStore.modeSet[mode]!;
    final rate = set.corrects.length / set.questions.length * 100;

    String result = "";
    if (rate == 100) {
      result = "你的脑洞超过了99%的童鞋。";
    } else if (rate >= 90) {
      result = "这就是你的极限吗";
    } else {
      result = GameStore.wrongAnswerTitle();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("$modeText已完成，你的成绩是"),
        ),
        body: Column(children: [
          const SizedBox(height: 50),
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .merge(const TextStyle(fontSize: 35)),
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                          "答对了${set.corrects.length}题。\n答错了${set.errors.length}题。\n正确率${rate.toStringAsFixed(0)}%\n$result")
                    ],
                  )))
        ]),
        floatingActionButton: FloatingActionButton(
            tooltip: "返回主界面",
            child: const Icon(Icons.assignment_return_rounded),
            onPressed: () {
              Navigator.pop(context);
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
