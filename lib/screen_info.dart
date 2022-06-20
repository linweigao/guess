import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guess/boxed_text.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  static final Uri _iOSUrl = Uri.parse(
      'https://apps.apple.com/us/app/%E8%84%91%E6%B4%9E%E5%A4%A7%E7%8C%9C/id1627959353');

  static final Uri _webUrl = Uri.parse("https://linweigao.github.io/guess/");

  _onApplePressed() async {
    if (!await launchUrl(_iOSUrl)) {
      throw 'Could not launch $_iOSUrl';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BoxedText(text: "感谢支持【脑洞大猜】", height: 200),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                      onPressed: null,
                      child: Row(children: const [
                        Icon(
                          Icons.android,
                          size: 50,
                        ),
                        Text(
                          " Google Play\n (Coming Soon)",
                        )
                      ]))),
            ],
          )
        ],
      ),
    );
  }
}
