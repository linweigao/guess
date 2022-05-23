import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  _onStartTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 100),
          alignment: Alignment.center,
          height: 500,
          child: Column(children: const [
            Text("🤯", style: TextStyle(fontSize: 300)),
            Text("脑洞大开", style: TextStyle(fontSize: 80))
          ]),
        ),
        Container(
          alignment: Alignment.center,
          height: 100,
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/game");
              },
              child: const Text("Start", style: TextStyle(fontSize: 80))),
        )
      ],
    ));
  }
}
