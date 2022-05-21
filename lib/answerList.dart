import 'package:flutter/material.dart';

class AnswerList extends StatefulWidget {
  AnswerList({super.key, required this.answers, required this.onAnswerSubmit});

  var answers = <String>[];
  ValueChanged<String> onAnswerSubmit;

  @override
  State<AnswerList> createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  _onTap(index) {
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
