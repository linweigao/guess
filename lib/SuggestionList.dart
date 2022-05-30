import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuggestionList extends StatefulWidget {
  const SuggestionList(
      {super.key, required this.answers, required this.onAnswerSubmit});

  final List<String> answers;
  final ValueChanged<String> onAnswerSubmit;

  @override
  State<SuggestionList> createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  _onTap(index) {
    SystemSound.play(SystemSoundType.click);
    widget.onAnswerSubmit(widget.answers[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
      itemCount: widget.answers.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () => _onTap(index),
            child: Center(child: Text(widget.answers[index])));
      },
    ));
  }
}
