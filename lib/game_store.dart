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
    "你的🧠怎么长的",
    "聪明绝顶👨‍🦲",
    "哎呦！不错哦",
    "你好，学霸",
    "是不是作弊了？",
  ];
  static final wrongAnswerTitles = [
    "不太聪明的样子",
    "脑洞要大🤯",
    "读书是不是有点少",
    "智商堪忧😱 ",
    "要不明天再来？",
    "不行的话可以多叫点人",
    "🐷🧠过载了吗？"
  ];
  static final shareQuestionTexts = [
    "【脑洞大猜】求助！这个题目【{question}{guess}】是什么啊？",
    "【脑洞大猜】在线等：题目【{question}{guess}】太变态了！",
    "【脑洞大猜】求大神：神仙题目【{question}{guess}】猜不出来！",
    "【脑洞大猜】我倒在了这题【{question}{guess}】上。"
  ];
  static final shareCorrectAnswerTexts = [
    "【脑洞大猜】这题目【{question}{guess}】，so easy！",
    "【脑洞大猜】【{question}{guess}】就这就这！",
    "【脑洞大猜】炸鱼：【{question}{guess}】这有什么难的！",
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
        return "乱斗挑战";
      case GameMode.free:
        return "休闲模式";
      case GameMode.chengyu:
        return "成语挑战";
      case GameMode.dongman:
        return "动漫挑战";
      case GameMode.renwu:
        return "中国人物";
      case GameMode.anime:
        return "Animes";
      case GameMode.movie:
        return "Movies";
      // case GameMode.test:
      //   return "测试挑战";
      default:
        return "";
    }
  }

  static String gameModeTitle(GameMode mode) {
    switch (mode) {
      case GameMode.all:
        return "乱斗挑战";
      case GameMode.free:
        return "休闲模式";
      case GameMode.chengyu:
        return "猜一个成语";
      case GameMode.dongman:
        return "猜动漫人物";
      case GameMode.renwu:
        return "猜中国人物";
      case GameMode.anime:
        return "Guess a Japan anime";
      case GameMode.movie:
        return "Guess a famous movie";
      // case GameMode.test:
      //   return "测试一下";
      default:
        return "";
    }
  }

  static String modeStatus(GameMode mode) {
    if (mode == GameMode.free) {
      return "(不计分)";
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
