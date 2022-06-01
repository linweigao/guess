import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guess/assets_utils.dart';

import 'data.dart';

class QuestionSet {
  final GameMode mode;
  QuestionSet(this.mode);

  late List<Question> questions;
  late List<String> answered;

  init() async {
    questions = await AssetsUtils.loadQuestion(mode);
    answered = await AssetsUtils.readSavedStrings(mode);
  }
}

class GameStore {
  static final modes = [GameMode.dongman, GameMode.chengyu, GameMode.test];
  static final correctAnswerTitles = [
    "你的🧠怎么长的",
    "聪明绝顶👨‍🦲",
    "哎呦！不错哦",
    "你好，学霸"
  ];
  static final wrongAnswerTitles = [
    "可惜，🧠不太聪明的样子",
    "脑洞要大🤯",
    "读书是不是有点少",
    "智商堪忧😱 ",
    "要不明天再来",
    "不行的话可以多叫点人"
  ];
  static final Map<GameMode, QuestionSet> modeSet = <GameMode, QuestionSet>{};
  static List<Question> allQuestions = [];
  static List<String> allAnswered = [];
  static List<String> chars = [];

  static Future init() async {
    await AssetsUtils.init();
    for (var mode in modes) {
      var questions = QuestionSet(mode);
      await questions.init();
      modeSet[mode] = questions;
      allQuestions.addAll(questions.questions);
      allAnswered.addAll(questions.answered);
    }

    var allSet = QuestionSet(GameMode.all);
    allSet.questions = allQuestions;
    allSet.answered = allAnswered;
    modeSet[GameMode.all] = allSet;

    var freeSet = QuestionSet(GameMode.casual);
    freeSet.questions = allQuestions;
    freeSet.answered = [];
    modeSet[GameMode.casual] = freeSet;

    chars = allQuestions
        .expand((e) => e.answer.characters.toList())
        .toSet()
        .toList();
  }

  static String gameModeText(GameMode mode) {
    switch (mode) {
      case GameMode.all:
        return "乱斗挑战";
      case GameMode.casual:
        return "休闲模式";
      case GameMode.chengyu:
        return "成语挑战";
      case GameMode.dongman:
        return "动漫挑战";
      case GameMode.test:
        return "测试挑战";
      default:
        return "";
    }
  }

  static String gameModeTitle(GameMode mode) {
    switch (mode) {
      case GameMode.all:
        return "乱斗挑战";
      case GameMode.casual:
        return "休闲模式";
      case GameMode.chengyu:
        return "猜一个成语";
      case GameMode.dongman:
        return "猜动漫人物";
      case GameMode.test:
        return "测试一下";
      default:
        return "";
    }
  }

  static String modeStatus(GameMode mode) {
    if (mode == GameMode.casual) {
      return "(不计分)";
    }

    QuestionSet? set = modeSet[mode]!;

    return "${set.answered.length} / ${set.questions.length}";
  }

  static String correctAnswerTitle() {
    return correctAnswerTitles[Random().nextInt(correctAnswerTitles.length)];
  }

  static String wrongAnswerTitle() {
    return wrongAnswerTitles[Random().nextInt(wrongAnswerTitles.length)];
  }

  static resetModeStatus(GameMode mode) async {
    if (mode == GameMode.casual) {
      return;
    }
    QuestionSet? set = modeSet[mode]!;
    set.answered.clear();
    await AssetsUtils.saveStrings(mode, set.answered);
  }

  static bool isModeComplete(GameMode mode) {
    QuestionSet? set = modeSet[mode]!;
    return set.answered.length == set.questions.length;
  }

  static List<Question> loadQuestion(GameMode mode) {
    final set = modeSet[mode]!;
    return set.questions
        .where((question) => !set.answered.contains(question.answer))
        .toList();
  }
}
