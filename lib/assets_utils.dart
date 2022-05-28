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
    final content = await rootBundle.loadString("$name.json");
    Iterable l = json.decode(content);
    List<Question> questions =
        List<Question>.from(l.map((model) => Question.fromJson(model, mode)));
    return questions;
  }

  static readSavedStrings(GameMode mode) {
    return _prefs!.getStringList(mode.toString()) ?? [];
  }

  static Future<bool> saveStrings(GameMode mode, List<String> value) async {
    return await _prefs!.setStringList(mode.toString(), value);
  }
}
