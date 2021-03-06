import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guess/assets_utils.dart';

import 'data.dart';

class QuestionSet {
  final GameMode mode;
  QuestionSet(this.mode);

  late List<Question> questions;
  late List<String> corrects;
  late List<String> errors;

  init() async {
    questions = await AssetsUtils.loadQuestion(mode);
    corrects = await AssetsUtils.readCorrectAnswered(mode);
    errors = await AssetsUtils.readErrorAnswered(mode);
  }
}

class GameStore {
  static final infoUrl = "https://linweigao.github.io/guess/#/info";

  static final modes = [
    GameMode.dongman,
    GameMode.chengyu,
    GameMode.renwu,
    GameMode.anime,
    GameMode.movie,
    // GameMode.test
  ];
  static final correctAnswerTitles = [
    "ä½ çð§ æä¹é¿ç",
    "èªæç»é¡¶ð¨âð¦²",
    "åå¦ï¼ä¸éå¦",
    "ä½ å¥½ï¼å­¦é¸",
    "æ¯ä¸æ¯ä½å¼äºï¼",
  ];
  static final wrongAnswerTitles = [
    "ä¸å¤ªèªæçæ ·å­",
    "èæ´è¦å¤§ð¤¯",
    "è¯»ä¹¦æ¯ä¸æ¯æç¹å°",
    "æºåå ªå¿§ð± ",
    "è¦ä¸æå¤©åæ¥ï¼",
    "ä¸è¡çè¯å¯ä»¥å¤å«ç¹äºº",
    "ð·ð§ è¿è½½äºåï¼"
  ];
  static final shareQuestionTexts = [
    "ãèæ´å¤§çãæ±å©ï¼è¿ä¸ªé¢ç®ã{question}{guess}ãæ¯ä»ä¹åï¼",
    "ãèæ´å¤§çãå¨çº¿ç­ï¼é¢ç®ã{question}{guess}ãå¤ªåæäºï¼",
    "ãèæ´å¤§çãæ±å¤§ç¥ï¼ç¥ä»é¢ç®ã{question}{guess}ãçä¸åºæ¥ï¼",
    "ãèæ´å¤§çãæåå¨äºè¿é¢ã{question}{guess}ãä¸ã"
  ];
  static final shareCorrectAnswerTexts = [
    "ãèæ´å¤§çãè¿é¢ç®ã{question}{guess}ãï¼so easyï¼",
    "ãèæ´å¤§çãã{question}{guess}ãå°±è¿å°±è¿ï¼",
    "ãèæ´å¤§çãç¸é±¼ï¼ã{question}{guess}ãè¿æä»ä¹é¾çï¼",
  ];
  static final Map<GameMode, QuestionSet> modeSet = <GameMode, QuestionSet>{};
  static List<Question> allQuestions = [];
  static List<String> chineseWords = [];
  static List<String> englishWords = [];
  static bool freeVisit = false;
  static bool allVisit = false;
  static String iconPath = "";

  static Future init() async {
    await AssetsUtils.init();
    // iconPath = await AssetsUtils.loadIcon();
    for (var mode in modes) {
      var questions = QuestionSet(mode);
      await questions.init();
      modeSet[mode] = questions;
      allQuestions.addAll(questions.questions);
    }

    var allSet = QuestionSet(GameMode.all);
    allSet.questions = allQuestions;
    allSet.corrects = await AssetsUtils.readCorrectAnswered(GameMode.all);
    allSet.errors = await AssetsUtils.readErrorAnswered(GameMode.all);
    modeSet[GameMode.all] = allSet;

    var freeSet = QuestionSet(GameMode.free);
    freeSet.questions = allQuestions;
    freeSet.corrects = [];
    freeSet.errors = [];
    modeSet[GameMode.free] = freeSet;

    chineseWords = allQuestions
        .where((q) => !isEnglishMode(q.mode))
        .expand((e) => e.answer.characters.toList())
        .toSet()
        .toList();

    englishWords = allQuestions
        .where((q) => isEnglishMode(q.mode))
        .expand((e) => e.answer.split(" "))
        .toSet()
        .toList();

    allVisit = AssetsUtils.readVisit(GameMode.all);
  }

  static setAllVisit() async {
    allVisit = true;
    await AssetsUtils.saveVisit(GameMode.all);
  }

  static String gameModeText(GameMode mode) {
    switch (mode) {
      case GameMode.all:
        return "ä¹±æææ";
      case GameMode.free:
        return "ä¼é²æ¨¡å¼";
      case GameMode.chengyu:
        return "æè¯­ææ";
      case GameMode.dongman:
        return "å¨æ¼«ææ";
      case GameMode.renwu:
        return "ä¸­å½äººç©";
      case GameMode.anime:
        return "Animes";
      case GameMode.movie:
        return "Movies";
      // case GameMode.test:
      //   return "æµè¯ææ";
      default:
        return "";
    }
  }

  static String gameModeTitle(GameMode mode) {
    switch (mode) {
      case GameMode.all:
        return "ä¹±æææ";
      case GameMode.free:
        return "ä¼é²æ¨¡å¼";
      case GameMode.chengyu:
        return "çä¸ä¸ªæè¯­";
      case GameMode.dongman:
        return "çå¨æ¼«äººç©";
      case GameMode.renwu:
        return "çä¸­å½äººç©";
      case GameMode.anime:
        return "Guess a Japan anime";
      case GameMode.movie:
        return "Guess a famous movie";
      // case GameMode.test:
      //   return "æµè¯ä¸ä¸";
      default:
        return "";
    }
  }

  static String modeStatus(GameMode mode) {
    if (mode == GameMode.free) {
      return "(ä¸è®¡å)";
    }

    QuestionSet? set = modeSet[mode]!;

    return "${set.corrects.length} / ${set.questions.length}";
  }

  static String shareQuestion(Question question) {
    return shareQuestionTexts[Random().nextInt(shareQuestionTexts.length)]
        .replaceFirst("{question}", question.question)
        .replaceFirst("{guess}", gameModeTitle(question.mode));
  }

  static String shareCorrectAnswer(Question question) {
    return shareCorrectAnswerTexts[
            Random().nextInt(shareCorrectAnswerTexts.length)]
        .replaceFirst("{question}", question.question)
        .replaceFirst("{guess}", gameModeTitle(question.mode));
  }

  static String correctAnswerTitle() {
    return correctAnswerTitles[Random().nextInt(correctAnswerTitles.length)];
  }

  static String wrongAnswerTitle() {
    return wrongAnswerTitles[Random().nextInt(wrongAnswerTitles.length)];
  }

  static bool isEnglishMode(GameMode mode) {
    if (mode == GameMode.anime || mode == GameMode.movie) {
      return true;
    }

    return false;
  }

  static resetErroreStatus(GameMode mode) async {
    QuestionSet set = modeSet[mode]!;
    set.errors.clear();

    if (mode == GameMode.free) {
      return;
    }

    await AssetsUtils.saveErrorAnswered(mode, set.corrects);
  }

  static increaseCorrectModeStatus(GameMode mode, Question question) {
    QuestionSet set = modeSet[mode]!;
    set.corrects.add(question.answer);

    if (mode == GameMode.free) {
      return;
    }
    AssetsUtils.saveCorrectAnswered(mode, set.corrects).then((value) => {});
  }

  static increaseErrorModeStatus(GameMode mode, Question question) {
    QuestionSet set = modeSet[mode]!;
    set.errors.add(question.answer);

    if (mode == GameMode.free) {
      return;
    }
    AssetsUtils.saveErrorAnswered(mode, set.errors).then((value) => {});
  }

  static bool isModeComplete(GameMode mode) {
    QuestionSet set = modeSet[mode]!;
    return set.corrects.length + set.errors.length == set.questions.length;
  }

  static List<Question> loadQuestion(GameMode mode) {
    final set = modeSet[mode]!;
    return set.questions
        .where((question) =>
            !set.corrects.contains(question.answer) &&
            !set.errors.contains(question.answer))
        .toList();
  }
}
