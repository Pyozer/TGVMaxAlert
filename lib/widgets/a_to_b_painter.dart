import 'package:flutter/material.dart';

class AToBPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.rotate(90 * 0.0174533);

    final circleRadius = 7.0;
    final lineHeight = 4.5;
    final circleStroke = 6.0;

    var paintCircle = Paint();
    paintCircle.color = Colors.white;
    paintCircle.style = PaintingStyle.stroke;
    paintCircle.strokeWidth = circleStroke;

    final circleLeftRect = Rect.fromLTWH(
      circleStroke / 2,
      circleStroke / 2,
      circleRadius * 2,
      circleRadius * 2,
    );
    canvas.drawArc(circleLeftRect, 0, 360 * 0.0174533, false, paintCircle);

    paintCircle.color = Colors.amber[700];
    final circleRightRect = Rect.fromLTWH(
      size.height - circleRadius * 2 - circleStroke / 2,
      circleStroke / 2,
      circleRadius * 2,
      circleRadius * 2,
    );
    canvas.drawArc(circleRightRect, 0, 360 * 0.0174533, false, paintCircle);

    final line = Rect.fromLTWH(
      circleRadius + circleStroke * 2,
      circleRadius - lineHeight / 2 + circleStroke / 2,
      size.height - circleRadius * 2 - circleStroke * 4,
      lineHeight,
    );

    var paintLine = Paint();
    paintLine.shader = LinearGradient(colors: [
      Colors.white,
      Colors.amber[700],
    ]).createShader(line);

    canvas.drawRect(line, paintLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
