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
  final GlobalKey _shareKey = GlobalKey();
  final _qrcode = const AssetImage('assets/images/qrcode.png');
  bool _qrCodeLoaded = false;
  bool _frameLoaded = false;

  _captureImageAndShare() async {
    if (kIsWeb) {
      return;
    }

    if (!_frameLoaded || !_qrCodeLoaded) {
      return;
    }

    try {
      BuildContext context = _genKey.currentContext!;
      RenderRepaintBoundary boundary =
          context.findRenderObject() as RenderRepaintBoundary;

      if (!kReleaseMode && boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
        return await _captureImageAndShare();
      }

      await Future.delayed(const Duration(milliseconds: 20));

      // ignore: use_build_context_synchronously
      MediaQueryData queryData = MediaQuery.of(context);
      final image =
          await boundary.toImage(pixelRatio: queryData.devicePixelRatio);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

      final tempDir = await getTemporaryDirectory();

      final filePath = "${tempDir.path}/share.png";
      final file = await File(filePath).create();
      file.writeAsBytesSync(byteData!.buffer.asUint8List());

      await Share.shareFilesWithResult([filePath],
          text: widget.shareText,
          subject: widget.shareText,
          sharePositionOrigin: shareButtonRect());

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (err) {
      await Share.shareWithResult(widget.shareText,
          subject: widget.shareText, sharePositionOrigin: shareButtonRect());
      // ignore: use_build_context_synchronously
      Navigator.pop(context, false);
    }
  }

  Rect shareButtonRect() {
    RenderBox renderBox =
        _shareKey.currentContext?.findRenderObject() as RenderBox;

    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return Rect.fromCenter(
      center: position + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        _frameLoaded = true;
        await _captureImageAndShare();
      }
    });
    _qrcode
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool syncCall) async {
      _qrCodeLoaded = true;
      await _captureImageAndShare();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final questionTitle = GameStore.gameModeTitle(question.mode);
    return RepaintBoundary(
        key: _genKey,
        child: Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 40, bottom: 20),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(widget.shareTitle,
                        style: const TextStyle(fontSize: 40)))),
            Expanded(child: BoxedText(text: question.question, height: 250)),
            const SizedBox(height: 25),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(questionTitle,
                        style: const TextStyle(fontSize: 30)))),
            const Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("知道答案⬇️扫码挑战", style: TextStyle(fontSize: 25)))),
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1 / 1,
                    key: _shareKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: _qrcode,
                          fit: BoxFit.scaleDown,
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 8,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )))
          ],
        )));
  }
}
