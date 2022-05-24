import 'package:guess/AssetsUtils.dart';
import 'package:guess/question.dart';

enum GameMode {
  casual,
  all,
  dongman,
  chengyu,
}

class GameStore {
  static List<Question> chengyu = [];
  static List<Question> dongman = [];

  static Future init() async {
    chengyu = await AssetsUtils.loadQuestion("chengyu.json");
    dongman = await AssetsUtils.loadQuestion("dongman.json");
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

  static List<Question> loadQuestion(GameMode mode) {
    switch (mode) {
      case GameMode.all:
        return chengyu + dongman;
      case GameMode.casual:
        return chengyu + dongman;
      case GameMode.chengyu:
        return chengyu;
      case GameMode.dongman:
        return dongman;
      default:
        return [];
    }
  }
}
