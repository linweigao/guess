import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:guess/question.dart';

class AssetsUtils {
  static Future<List<Question>> loadQuestion(String path) async {
    final content = await rootBundle.loadString(path);
    Iterable l = json.decode(content);
    List<Question> questions =
        List<Question>.from(l.map((model) => Question.fromJson(model)));
    return questions;
  }
}
