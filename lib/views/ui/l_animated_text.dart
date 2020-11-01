import 'package:flutter/material.dart';

class LAnimatedText extends StatelessWidget {
  final int duration;
  final String text;
  final TextStyle style;
  LAnimatedText({
    Key key,
    @required this.text,
    duration,
    this.style,
  })  : this.duration = duration ?? 15 * text.length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
        tween: StepTween(begin: 0, end: text.length),
        duration: Duration(milliseconds: duration),
        builder: (BuildContext context, int size, Widget child) {
          String printed = text.substring(0, size);
          return Text(
            printed,
            style: style,
          );
        });
  }
}
