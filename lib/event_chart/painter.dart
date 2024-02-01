import 'dart:math';

import 'package:flutter/material.dart';

const startAngle = -pi / 2;

void paintFilledCircle(Canvas canvas, Offset center, double r, Color c) {
  canvas.drawCircle(center, r, Paint()..color = c);
}

void paintRingSection(Canvas canvas, Offset center, double angle,
    double sweepAngle, Color c, double startRadius, double width) {
  // offset by pi/2 to start at 12 o'clock
  angle += startAngle;

  canvas.drawArc(
    Rect.fromCircle(center: center, radius: startRadius),
    angle,
    sweepAngle,
    false,
    Paint()
      ..isAntiAlias = true
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = width,
  );
}

// this is a 24 hour clock, i.e. starts at 12 midnight, and when completed ends at 12 midnight
void paintClock(Canvas canvas, Offset center, double r) {
  paintFilledCircle(canvas, center, r, Colors.grey.shade200);
  var ticks = 6; // can be 24, 12, 6, 4, 3, 2
  var tickAngle = 2 * pi / ticks;
  var tickLength = r / 10;
  var tickWidth = 2.0;

  for (var i = 0; i < ticks; i++) {
    // draw as lines
    var angle = i * tickAngle + startAngle;
    var x1 = center.dx + r * cos(angle);
    var y1 = center.dy + r * sin(angle);
    var x2 = center.dx + (r - tickLength) * cos(angle);
    var y2 = center.dy + (r - tickLength) * sin(angle);
    canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..isAntiAlias = true
          ..color = Colors.grey.shade400
          ..style = PaintingStyle.stroke
          ..strokeWidth = tickWidth);
  }

  // draw the clock tick labels
  var labelRadius = r - tickLength - 12;
  var labelOffset = 0.0;
  var labelStyle = TextStyle(
    color: Colors.grey.shade600,
    fontSize: 12,
  );

  var labelValue = 0;
  for (var i = 0; i < ticks; i++) {
    var angle = i * tickAngle + startAngle;
    var x = center.dx + labelRadius * cos(angle);
    var y = center.dy + labelRadius * sin(angle);
    labelValue = i * (24 ~/ ticks);
    var label = (labelValue).toString();
    var textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: labelStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2,
            y - textPainter.height / 2 - labelOffset));
  }
}

class EventsChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;

    final clockRadius = 2 * maxRadius / 3;
    paintClock(canvas, center, clockRadius);

    const maxRings = 3;
    const ringGap = 2;
    final ringWidth = (maxRadius - clockRadius - ringGap * maxRings) / maxRings;

    List<double> rings = [];
    for (var i = 0; i < maxRings; i++) {
      final r = clockRadius + ringGap * (i + 1) + (i * 2 + 1) * ringWidth / 2;
      rings.add(r);
    }

    paintRingSection(
        canvas, center, 0, pi / 2, Colors.red, rings[0], ringWidth);
    paintRingSection(
        canvas, center, pi / 8, pi / 3, Colors.red, rings[1], ringWidth);
    paintRingSection(
        canvas, center, pi / 4, pi, Colors.red, rings[2], ringWidth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
