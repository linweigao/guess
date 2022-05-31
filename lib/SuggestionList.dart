import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuggestionList extends StatefulWidget {
  const SuggestionList(
      {super.key,
      required this.answers,
      required this.onAnswerSubmit,
      required this.hintAnswer});

  final List<String> answers;
  final ValueChanged<String> onAnswerSubmit;
  final String hintAnswer;

  @override
  State<SuggestionList> createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  _onTap(answer) {
    if (answer == widget.hintAnswer) {
      return;
    }

    SystemSound.play(SystemSoundType.click);
    widget.onAnswerSubmit(answer);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, mainAxisSpacing: 6, childAspectRatio: (1 / 0.5)),
      itemCount: widget.answers.length,
      itemBuilder: (BuildContext context, int index) {
        final answer = widget.answers[index];
        if (answer == widget.hintAnswer) {
          return Stack(children: [
            Center(
                child: Text("X",
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.merge(const TextStyle(color: Colors.red)))),
            Center(
                child:
                    Text(answer, style: Theme.of(context).textTheme.bodyMedium))
          ]);
        }
        return InkWell(
            onTap: () => _onTap(answer),
            child: Center(
                child: Text(answer,
                    style: Theme.of(context).textTheme.bodyMedium)));
      },
    );
  }
}
