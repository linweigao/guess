import 'package:flutter/material.dart';
import 'package:guess/game_store.dart';
import 'package:guess/guess.dart';

import 'data.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _init = false;
  bool _showMenu = false;

  Widget _buildMenu(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16),
      itemCount: GameMode.values.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Guess(mode: GameMode.values[index]);
              }));
            },
            child: Center(
                child: Column(children: [
              Text(GameStore.gameModeText(GameMode.values[index])),
              Text(GameStore.modeStatus(GameMode.values[index]))
            ])));
      },
    ));
  }

  @override
  void initState() {
    super.initState();
    GameStore.init().then((x) => {
          setState(() {
            _init = true;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_showMenu) {
      return _buildMenu(context);
    }

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
          child: _init
              ? InkWell(
                  onTap: () {
                    setState(() {
                      _showMenu = true;
                    });
                  },
                  child: const Text("Tap to continue...",
                      style: TextStyle(fontSize: 80)))
              : const Text("loading...", style: TextStyle(fontSize: 80)),
        )
      ],
    ));
  }
}
