enum GameMode {
  free,
  all,
  dongman,
  chengyu,
  renwu,
  anime,
  test,
}

class Question {
  final String question;
  final String answer;
  final String answerDialog;
  final GameMode mode;
  Question(this.question, this.answer, this.answerDialog, this.mode);

  Question.fromJson(Map<String, dynamic> json, this.mode)
      : question = json['question'],
        answer = json['answer'],
        answerDialog = json.containsKey("dialog") ? json["dialog"] : "";
}
