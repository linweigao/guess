import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:guess/screen_start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
        builder: (context) {
          return MaterialApp(
              title: '脑洞大猜',
              debugShowCheckedModeBanner: false,
              darkTheme: ThemeData(
                  brightness: Brightness.dark, primarySwatch: Colors.grey),
              themeMode: ThemeMode.dark,
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              home: const StartScreen());
        },
        maximumSize: const Size(800, double.infinity),
        enabled: kIsWeb,
        backgroundColor: Colors.grey);
  }
}
