import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptionsList extends StatefulWidget {
  const OptionsList(
      {super.key,
      required this.options,
      required this.onOptionSubmit,
      required this.hideOption});

  final List<String> options;
  final ValueChanged<String> onOptionSubmit;
  final String hideOption;

  @override
  State<OptionsList> createState() => _OptionsListState();
}

class _OptionsListState extends State<OptionsList> {
  _onTap(answer) {
    if (answer == widget.hideOption) {
      return;
    }

    SystemSound.play(SystemSoundType.click);
    widget.onOptionSubmit(answer);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 6,
          childAspectRatio: (1 / 0.5),
          mainAxisExtent: 60),
      itemCount: widget.options.length,
      itemBuilder: (BuildContext context, int index) {
        final answer = widget.options[index];
        if (answer == widget.hideOption) {
          return Stack(children: [
            Center(
                child: Text(answer,
                    style: Theme.of(context).textTheme.bodyMedium)),
            Center(
                child:
                    Text("❌", style: Theme.of(context).textTheme.bodyMedium)),
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
