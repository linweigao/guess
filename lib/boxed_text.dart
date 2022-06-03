import 'package:flutter/material.dart';

class BoxedText extends StatelessWidget {
  final String text;
  final double height;
  final Color boxColor;
  final Color textColor;
  const BoxedText(
      {super.key,
      required this.text,
      required this.height,
      this.boxColor = Colors.white,
      this.textColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Container(
          padding: const EdgeInsets.all(3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(30),
          ),
          height: height,
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.merge(TextStyle(color: textColor)),
              )),
        ));
  }
}
