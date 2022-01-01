import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';
import 'package:lastochki/views/ui/l_animated_text.dart';

enum Side { LEFT, RIGHT, CENTER }

class PanelPainter extends CustomPainter {
  final double radius;
  final Side side;
  final bool isThinking;

  PanelPainter(
      {@required this.radius, @required this.side, this.isThinking = false});

  @override
  void paint(Canvas canvas, Size size) {
    const height = 25.0;
    final Offset topRightCenter = Offset(size.width - radius, radius + height);
    final Offset bottomRightCenter =
        Offset(size.width - radius, size.height - radius);
    final Offset bottomLeftCenter = Offset(radius, size.height - radius);
    final Offset topLeftCenter = Offset(radius, radius + height);

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = boxBorderColor;

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = whiteColor;

    final Path path = Path()
      ..moveTo(radius + height / 2, height)
      ..arcTo(Rect.fromCircle(center: topRightCenter, radius: radius), -pi / 2,
          pi / 2, false)
      ..lineTo(size.width, size.height - radius)
      ..arcTo(Rect.fromCircle(center: bottomRightCenter, radius: radius), 0,
          pi / 2, false)
      ..lineTo(radius, size.height)
      ..arcTo(Rect.fromCircle(center: bottomLeftCenter, radius: radius), pi / 2,
          pi / 2, false)
      ..lineTo(0.0, radius + height)
      ..arcTo(Rect.fromCircle(center: topLeftCenter, radius: radius), pi,
          pi / 2, false)
      ..lineTo(radius + height / 2, height);

    final Path leftPath = Path()
      ..moveTo(radius + height / 2 - 1, height)
      ..lineTo(radius + height / 2 + height, 0.0)
      ..lineTo(radius + height / 2 + height, height)
      ..lineTo(size.width - radius, height)
      ..arcTo(Rect.fromCircle(center: topRightCenter, radius: radius), -pi / 2,
          pi / 2, false)
      ..lineTo(size.width, size.height - radius)
      ..arcTo(Rect.fromCircle(center: bottomRightCenter, radius: radius), 0,
          pi / 2, false)
      ..lineTo(radius, size.height)
      ..arcTo(Rect.fromCircle(center: bottomLeftCenter, radius: radius), pi / 2,
          pi / 2, false)
      ..lineTo(0.0, radius + height)
      ..arcTo(Rect.fromCircle(center: topLeftCenter, radius: radius), pi,
          pi / 2, false)
      ..lineTo(radius + height / 2, height);

    final Path rightPath = Path()
      ..moveTo(size.width - radius - height / 2 - height, height + 2)
      ..lineTo(size.width - radius - height / 2 - height, 0.0)
      ..lineTo(size.width - radius - height / 2, height)
      ..lineTo(size.width - radius, height)
      ..arcTo(Rect.fromCircle(center: topRightCenter, radius: radius), -pi / 2,
          pi / 2, false)
      ..lineTo(size.width, size.height - radius)
      ..arcTo(Rect.fromCircle(center: bottomRightCenter, radius: radius), 0,
          pi / 2, false)
      ..lineTo(radius, size.height)
      ..arcTo(Rect.fromCircle(center: bottomLeftCenter, radius: radius), pi / 2,
          pi / 2, false)
      ..lineTo(0.0, radius + height)
      ..arcTo(Rect.fromCircle(center: topLeftCenter, radius: radius), pi,
          pi / 2, false)
      ..lineTo(size.width - radius - height / 2 - height, height);

    Path currentPath;
    switch (side) {
      case Side.LEFT:
        currentPath = leftPath;
        break;
      case Side.RIGHT:
        currentPath = rightPath;
        break;
      default:
        {
          currentPath = path;
        }
    }

    canvas.drawShadow(currentPath, Colors.black.withOpacity(0.6), 10.0, true);
    canvas.drawPath(currentPath, fillPaint);
    canvas.drawPath(currentPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LSpeechPanel extends StatelessWidget {
  final String name;
  final String speech;
  final bool isLeftSide;
  final bool isThinking;
  final GlobalKey textKey = GlobalKey();

  LSpeechPanel({
    @required this.name,
    @required this.speech,
    this.isLeftSide = true,
    this.isThinking = false,
  });

  Widget _buildNamePanel() {
    return Positioned(
      left: isLeftSide ? 24.0 : null,
      right: isLeftSide ? null : 24.0,
      top: 5.0,
      child: Container(
        height: 30.0,
        margin: isLeftSide
            ? EdgeInsets.only(left: 32.0)
            : EdgeInsets.only(right: 32.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Color(0xFF1675CC),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                name.toUpperCase(),
                style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Side side = Side.CENTER;
    TextStyle style = contentTextStyle;
    String text = speech;
    if (name != null && !isThinking) {
      side = isLeftSide ? Side.LEFT : Side.RIGHT;
    }
    if (speech.startsWith('i:')) {
      style = contentTextStyle.copyWith(fontStyle: FontStyle.italic);
      text = speech.substring(2);
    }
    final String preparedText = text;

    return Container(
      width: double.infinity,
      child: CustomPaint(
        painter: PanelPainter(
          radius: 12.0,
          side: side,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isThinking)
              Positioned(
                top: -24,
                left: 24,
                child: Image.asset('assets/icons/think.png'),
                width: 36,
              ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 40.0, right: 24.0, bottom: 20),
              child: Stack(
                children: [
                  LAnimatedText(
                    key: Key(text),
                    text: preparedText,
                    style: style,
                  ),
                  ShaderMask(
                    blendMode: BlendMode.srcOut,
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: [Colors.white], stops: [0.0])
                            .createShader(bounds),
                    child: Text(preparedText,
                        key: textKey,
                        style: style.copyWith(
                          color: Colors.black,
                        )),
                  )
                ],
              ),
            ),
            if (name != null) _buildNamePanel(),
          ],
        ),
      ),
    );
  }
}
