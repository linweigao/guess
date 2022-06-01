import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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

  static readAnswered(GameMode mode) {
    return _prefs!.getStringList(mode.toString()) ?? [];
  }

  static Future<bool> saveAnswered(GameMode mode, List<String> value) async {
    return await _prefs!.setStringList(mode.toString(), value);
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
