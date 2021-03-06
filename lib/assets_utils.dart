import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

class AssetsUtils {
  static SharedPreferences? _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<List<Question>> loadQuestion(GameMode mode) async {
    var name = mode.toString().split('.').last;
    final content = await rootBundle.loadString("assets/$name.json");
    Iterable l = json.decode(content);
    List<Question> questions =
        List<Question>.from(l.map((model) => Question.fromJson(model, mode)));
    return questions;
  }

  static Future<String> loadIcon() async {
    final bytes = await rootBundle.load("assets/icon_160.png");
    final tempDir = await getTemporaryDirectory();
    final filePath = "${tempDir.path}/image.jpg";
    final file = await File(filePath).create();
    file.writeAsBytesSync(bytes.buffer.asUint8List());

    return filePath;
  }

  static readCorrectAnswered(GameMode mode) {
    return _prefs!.getStringList("$mode.correct") ?? [];
  }

  static Future<bool> saveCorrectAnswered(
      GameMode mode, List<String> value) async {
    return await _prefs!.setStringList("$mode.correct", value);
  }

  static readErrorAnswered(GameMode mode) {
    return _prefs!.getStringList("$mode.error") ?? [];
  }

  static Future<bool> saveErrorAnswered(
      GameMode mode, List<String> value) async {
    return await _prefs!.setStringList("$mode.error", value);
  }

  static bool readVisit(GameMode mode) {
    final visit = _prefs!.getBool("$mode.visit");
    if (visit == null) {
      return false;
    }

    return visit;
  }

  static Future<bool> saveVisit(GameMode mode) async {
    return await _prefs!.setBool("$mode.visit", true);
  }
}
