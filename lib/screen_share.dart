import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guess/game_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'boxed_text.dart';
import 'data.dart';

class ShareScreen extends StatefulWidget {
  final String shareTitle;
  final String shareText;
  final Question question;

  const ShareScreen(
      {Key? key,
      required this.shareTitle,
      required this.shareText,
      required this.question})
      : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final GlobalKey _genKey = GlobalKey();

  _captureImageAndShare() async {
    if (kIsWeb) {
      return;
    }
    BuildContext context = _genKey.currentContext!;
    RenderRepaintBoundary boundary =
        context.findRenderObject() as RenderRepaintBoundary;

    //if (boundary.debugNeedsPaint) {
    await Future.delayed(const Duration(milliseconds: 20));
    //return await _captureImageAndShare();
    // }

    // ignore: use_build_context_synchronously
    MediaQueryData queryData = MediaQuery.of(context);
    final image =
        await boundary.toImage(pixelRatio: queryData.devicePixelRatio);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    final tempDir = await getTemporaryDirectory();

    final filePath = "${tempDir.path}/share.png";
    final file = await File(filePath).create();
    file.writeAsBytesSync(byteData!.buffer.asUint8List());

    await Share.shareFiles([filePath],
        text: widget.shareText, subject: widget.shareText);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) _captureImageAndShare();
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final questionTitle = GameStore.gameModeTitle(question.mode);
    return RepaintBoundary(
        key: _genKey,
        child: Scaffold(
            body: Column(
          children: [
            const SizedBox(height: 25),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(widget.shareTitle,
                        style: const TextStyle(fontSize: 40)))),
            const SizedBox(height: 25),
            BoxedText(text: question.question, height: 250),
            const SizedBox(height: 25),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(questionTitle,
                        style: const TextStyle(fontSize: 30)))),
            const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("知道答案⬇️扫码挑战", style: TextStyle(fontSize: 25)))),
            const SizedBox(height: 25),
            SizedBox(
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/qrcode.png'),
                      fit: BoxFit.scaleDown,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 8,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ))
          ],
        )));
  }
}
