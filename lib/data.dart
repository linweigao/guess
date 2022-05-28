enum GameMode {
  casual,
  all,
  dongman,
  chengyu,
}

class Question {
  final String question;
  final String answer;
  final GameMode mode;
  Question(this.question, this.answer, this.mode);

  Question.fromJson(Map<String, dynamic> json, this.mode)
      : question = json['question'],
        answer = json['answer'];
}
