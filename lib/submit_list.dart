import 'package:flutter/material.dart';

class SubmitList extends StatefulWidget {
  const SubmitList(
      {super.key,
      required this.submitAnswer,
      required this.answer,
      required this.onSubmitCleared,
      required this.onSubmitRemoved});

  final List<String> submitAnswer;
  final List<String> answer;
  final Function onSubmitRemoved;
  final Function onSubmitCleared;

  @override
  State<SubmitList> createState() => _SubmitListState();
}

class _SubmitListState extends State<SubmitList> {
  _onAnswerRemoved() {
    widget.onSubmitRemoved();
  }

  _onAnswerCleared() {
    widget.onSubmitCleared();
  }

  @override
  Widget build(BuildContext context) {
    final answer = widget.answer.toList();
    double width = 80;
    if (widget.answer.length == 5) {
      width = 60;
    }

    return SizedBox(
        height: 90,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: answer.length + 1,
          itemBuilder: (context, index) {
            // render "remove" button
            if (index == answer.length) {
              return SizedBox(
                  width: 40,
                  child: FittedBox(
                      child: InkWell(
                          onTap: _onAnswerRemoved,
                          onLongPress: _onAnswerCleared,
                          child: const Icon(Icons.backspace))));
            }

            // render submitted answers
            final answerChar = index < widget.submitAnswer.length
                ? widget.submitAnswer[index]
                : "";

            return Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: Color(Colors.yellow.value))),
                width: width,
                child: FittedBox(child: Text(answerChar)));
          },
        ));
  }
}
