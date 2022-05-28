import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:guess/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsUtils {
  static SharedPreferences? _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<List<Question>> loadQuestion(String path) async {
    final content = await rootBundle.loadString(path);
    Iterable l = json.decode(content);
    List<Question> questions =
        List<Question>.from(l.map((model) => Question.fromJson(model)));
    return questions;
  }

  static readSavedStrings(String key) {
    return _prefs?.getStringList(key) ?? [];
  }

  static saveStrings(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value);
  }
}
