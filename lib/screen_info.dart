import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guess/boxed_text.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  static final Uri _iOSUrl = Uri.parse(
      'https://apps.apple.com/us/app/%E8%84%91%E6%B4%9E%E5%A4%A7%E7%8C%9C/id1627959353');

  static final Uri _webUrl = Uri.parse("https://linweigao.github.io/guess/");

  static final Uri _androidUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.studio120.guess');

  static final Uri _ideasUrl =
      Uri.parse("https://github.com/linweigao/guess/issues");

  _onApplePressed() async {
    if (!await launchUrl(_iOSUrl)) {
      throw 'Could not launch $_iOSUrl';
    }
  }

  _onGooglePressed() async {
    if (!await launchUrl(_androidUrl)) {
      throw 'Could not launch $_androidUrl';
    }
  }

  _onWebPressed(BuildContext context) async {
    if (kIsWeb) {
      Navigator.pop(context);
    } else {
      if (!await launchUrl(_webUrl)) {
        throw 'Could not launch $_webUrl';
      }
    }
  }

  _onIdeasPressed() async {
    if (!await launchUrl(_ideasUrl)) {
      throw 'Could not launch $_ideasUrl';
    }
  }

  _buildActionButtons(context) {
    return [
      Container(
          padding: const EdgeInsets.all(8),
          width: 200,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Foreground color
                onPrimary: Colors.white,
                // Background color
                primary: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: _onApplePressed,
              child: Row(children: const [
                Icon(
                  Icons.apple,
                  size: 50,
                ),
                Text(
                  " Download on\n App Store",
                )
              ]))),
      Container(
          padding: const EdgeInsets.all(8),
          width: 200,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Foreground color
                onPrimary: Colors.white,
                // Background color
                primary: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: () async {
                await _onWebPressed(context);
              },
              child: Row(children: const [
                Icon(
                  Icons.web_asset,
                  size: 50,
                ),
                Text(
                  " Play on\n Web Broswer",
                )
              ]))),
      Container(
          padding: const EdgeInsets.all(8),
          width: 200,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Foreground color
                onPrimary: Colors.white,
                // Background color
                primary: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: _onGooglePressed,
              child: Row(children: const [
                Icon(
                  Icons.android,
                  size: 50,
                ),
                Text(
                  " Download on\n Google Play",
                )
              ])))
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final actionBars = width >= 600
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildActionButtons(context),
          )
        : Column(children: _buildActionButtons(context));

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: BoxedText(text: "??????????????????????????????", height: 150)),
          const SizedBox(
            height: 20,
          ),
          actionBars,
          Expanded(
              flex: 3,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 20),
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text("Special Thanks / ????????????",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 36)),
                          const Text("Lisa Gao / ?????????",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 28)),
                          Expanded(child: Container()),
                          const Text("providing ideas / ?????????????????? ",
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 20)),
                          const SizedBox(height: 20),
                          TextButton(
                              onPressed: _onIdeasPressed,
                              child: const Text(
                                  "** Contact us if you have great puzzle ideas.",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      decoration: TextDecoration.underline))),
                          const SizedBox(height: 20)
                        ],
                      )))),
        ],
      ),
    );
  }
}
