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
  static final modes = [GameMode.dongman, GameMode.chengyu];
  static final Map<GameMode, QuestionSet> modeSet = <GameMode, QuestionSet>{};
  static List<Question> all = [];
  static List<String> chars = [];

  static Future init() async {
    await AssetsUtils.init();
    for (var mode in modes) {
      var questions = QuestionSet(mode);
      await questions.init();
      modeSet[mode] = questions;
      all.addAll(questions.questions);
    }

    chars = all.expand((e) => e.answer.characters.toList()).toSet().toList();
  }

  static String gameModeText(GameMode mode) {
    switch (mode) {
      case GameMode.all:
        return "乱斗模式";
      case GameMode.casual:
        return "休闲模式";
      case GameMode.chengyu:
        return "成语模式";
      case GameMode.dongman:
        return "动漫模式";
      default:
        return "";
    }
  }

  static String modeStatus(GameMode mode) {
    QuestionSet? set = modeSet[mode];

    if (set != null) {
      return "${set.answered.length} / ${set.questions.length}";
    }

    return "";
  }

  static List<Question> loadQuestion(GameMode mode) {
    switch (mode) {
      case GameMode.all:
        return all;
      case GameMode.casual:
        return all;
      case GameMode.chengyu:
        return modeSet[GameMode.chengyu]!.questions;
      case GameMode.dongman:
        return modeSet[GameMode.dongman]!.questions;
      default:
        return [];
    }
  }
}
