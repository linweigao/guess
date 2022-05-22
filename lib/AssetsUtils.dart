import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:guess/question.dart';

class AssetsUtils {
  static Future<List<Question>> loadQuestion() async {
    final content = await rootBundle.loadString("assets/questions.json");
    Iterable l = json.decode(content);
    List<Question> questions =
        List<Question>.from(l.map((model) => Question.fromJson(model)));
    return questions;
  }
}
