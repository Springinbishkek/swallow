import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lastochki/views/theme.dart';

class PanelPainter extends CustomPainter {
  final double radius;
  final bool isLeftSide;

  PanelPainter({@required this.radius, @required this.isLeftSide});

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

    final Path leftPath = Path()
      ..moveTo(radius + height / 2, height)
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
      ..moveTo(size.width - radius - height / 2 - height, height)
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

    canvas.drawShadow(isLeftSide ? leftPath : rightPath,
        Colors.grey.withOpacity(0.6), 10.0, true);
    canvas.drawPath(isLeftSide ? leftPath : rightPath, fillPaint);
    canvas.drawPath(isLeftSide ? leftPath : rightPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LSpeechPanel extends StatelessWidget {
  final String name;
  final String speech;
  final bool isLeftSide;

  LSpeechPanel(
      {@required this.name, @required this.speech, this.isLeftSide = true});

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
            color: Color(0xFF48BFF5)),
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
    return Container(
      child: CustomPaint(
        painter: PanelPainter(radius: 12.0, isLeftSide: isLeftSide),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 40.0, right: 24.0, bottom: 16.0),
              child: Text(
                speech,
                style: contentTextStyle,
              ),
            ),
            _buildNamePanel(),
          ],
        ),
      ),
    );
  }
}
