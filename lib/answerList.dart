import 'package:flutter/material.dart';

class AnswerList extends StatefulWidget {
  const AnswerList(
      {super.key,
      required this.submitAnswer,
      required this.answer,
      required this.showHint,
      required this.onAnswerCleared,
      required this.onAnswerRemoved});

  final String submitAnswer;
  final String answer;
  final bool showHint;
  final Function onAnswerRemoved;
  final Function onAnswerCleared;

  @override
  State<AnswerList> createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  _onAnswerRemoved() {
    widget.onAnswerRemoved();
  }

  _onAnswerCleared() {
    widget.onAnswerCleared();
  }

  @override
  Widget build(BuildContext context) {
    final answer = widget.answer.characters.toList();

    return SizedBox(
        height: 100,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: answer.length + 1,
          itemBuilder: (context, index) {
            // render "remove" button
            if (index == answer.length) {
              if (widget.submitAnswer.isEmpty) {
                return Container();
              }

              return InkWell(
                  onTap: _onAnswerRemoved,
                  onLongPress: _onAnswerCleared,
                  child: const Icon(Icons.backspace));
            }

            // render submitted answers
            final answerChar = index < widget.submitAnswer.length
                ? widget.submitAnswer[index]
                : "";

            return Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: Color(Colors.green.value))),
                width: 100,
                child: Center(child: Text(answerChar)));
          },
        ));
  }
}
