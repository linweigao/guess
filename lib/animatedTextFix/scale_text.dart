import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ScaleAnimatedTextFix extends AnimatedText {
  /// Set the scaling factor of the text for the animation.
  ///
  /// By default it is set to [double] value 0.5
  final double scalingFactor;

  ScaleAnimatedTextFix(
    String text, {
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    Duration duration = const Duration(milliseconds: 1000),
    this.scalingFactor = 0.5,
  }) : super(
          text: text,
          textAlign: textAlign,
          textStyle: textStyle,
          duration: duration,
        );

  late Animation<double> _scaleIn, _scaleOut;

  @override
  void initAnimation(AnimationController controller) {
    _scaleIn = Tween<double>(begin: scalingFactor, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
    _scaleOut = Tween<double>(begin: 1.0, end: scalingFactor).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  Widget completeText(BuildContext context) => SizedBox.shrink();

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return ScaleTransition(
      scale: _scaleIn.value != 1.0 ? _scaleIn : _scaleOut,
      child: textWidget(text),
    );
  }
}
