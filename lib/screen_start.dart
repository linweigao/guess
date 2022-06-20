import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:guess/game_store.dart';
import 'package:guess/screen_game.dart';

import 'data.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _init = false;
  bool _showMenu = false;

  Future _navigateGame(BuildContext context, GameMode mode) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Game(mode: mode);
    }));
    setState(() {});
    return;
  }

  Widget _buildMenu(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("🤯 脑洞大猜  请你挑战 🤯")),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: GameMode.values.length,
          itemBuilder: (BuildContext context, int index) {
            final mode = GameMode.values[index];
            final isComplete = GameStore.isModeComplete(mode);
            final modeText = GameStore.gameModeText(mode);
            final modeStyle = Theme.of(context).textTheme.headline3;

            return Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 131, 126, 126),
                  border: Border.all(
                    color: Colors.black,
                    width: 8,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    if (mode == GameMode.free) {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(modeText,
                              style: Theme.of(context).textTheme.headline3),
                          content: Text(
                              '该模式不记分\n挑战所有题库\n适合多人游玩\n比比谁最聪明\n确认要开始吗？',
                              style: Theme.of(context).textTheme.headline4),
                          actions: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: IconButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  icon:
                                      const Icon(Icons.highlight_off, size: 40),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 20),
                                child: IconButton(
                                  onPressed: () async {
                                    Navigator.pop(context, true);
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    size: 40,
                                  ),
                                )),
                          ],
                        ),
                      );

                      if (ok == true) {
                        // ignore: use_build_context_synchronously
                        await _navigateGame(context, mode);
                      }
                      return;
                    }

                    if (mode == GameMode.all && !GameStore.allVisit) {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(modeText,
                              style: Theme.of(context).textTheme.headline3),
                          content: Text('挑战所有题库\n建议上知天文\n下知English\n确认要开始吗？',
                              style: Theme.of(context).textTheme.headline4),
                          actions: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: IconButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  icon:
                                      const Icon(Icons.highlight_off, size: 40),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 20),
                                child: IconButton(
                                  onPressed: () async {
                                    Navigator.pop(context, true);
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    size: 40,
                                  ),
                                )),
                          ],
                        ),
                      );

                      if (ok == true) {
                        await GameStore.setAllVisit();
                        // ignore: use_build_context_synchronously
                        await _navigateGame(context, mode);
                      }
                      return;
                    }

                    if (GameStore.isModeComplete(mode)) {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("挑战已完成",
                              style: Theme.of(context).textTheme.headline3),
                          content: Text('确认要重新挑战错误题目吗？',
                              style: Theme.of(context).textTheme.headline4),
                          actions: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: IconButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  icon:
                                      const Icon(Icons.highlight_off, size: 40),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 20),
                                child: IconButton(
                                  onPressed: () async {
                                    Navigator.pop(context, true);
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    size: 40,
                                  ),
                                )),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await GameStore.resetErroreStatus(mode);
                        // ignore: use_build_context_synchronously
                        await _navigateGame(context, mode);
                      }
                    } else {
                      await _navigateGame(context, mode);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            modeText,
                            style: modeStyle,
                            textAlign: TextAlign.center,
                          )),
                      Text(GameStore.modeStatus(mode),
                          style: Theme.of(context).textTheme.bodyMedium),
                      const Spacer(),
                      isComplete
                          ? const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.assignment_turned_in_sharp,
                                size: 40,
                                color: Colors.yellow,
                              ))
                          : Container(),
                      const SizedBox(height: 70)
                    ],
                  ),
                ));
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
        body: InkWell(
            onTap: () {
              if (_init) {
                setState(() {
                  _showMenu = true;
                });
              }
            },
            child: Stack(
              children: [
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                            height: 400,
                            fit: BoxFit.scaleDown,
                            image: AssetImage('assets/images/qrcode.png')),
                        const Text("脑洞大猜", style: TextStyle(fontSize: 80)),
                        Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: _init
                              ? DefaultTextStyle(
                                  style: const TextStyle(fontSize: 60),
                                  child: AnimatedTextKit(
                                      onTap: () {
                                        setState(() {
                                          _showMenu = true;
                                        });
                                      },
                                      displayFullTextOnTap: true,
                                      repeatForever: true,
                                      animatedTexts: [
                                        FlickerAnimatedText("👆🏻",
                                            speed: const Duration(
                                                milliseconds: 1000))
                                      ]))
                              : const Text("🚥",
                                  style: TextStyle(fontSize: 60)),
                        )
                      ]),
                ),
              ],
            )));
  }
}
