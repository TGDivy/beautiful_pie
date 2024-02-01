import 'dart:math';

import 'package:beautiful_pie/events_chart/data.dart';
import 'package:flutter/material.dart';

void paintFilledCircle(Canvas canvas, Offset p, double r, Color c) {
  canvas.drawCircle(p, r, Paint()..color = c);
}

class PieChartPainter extends CustomPainter {
  final PieChartData data;
  final Animation<double> animation;

  const PieChartPainter({required this.data, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final totalPercentage = data.sections.fold<double>(
      0,
      (previousValue, element) => previousValue + element.value,
    );
    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    paintFilledCircle(canvas, center, radius, data.backgroundCircleColor);

    var startAngle = -pi / 2;

    var pSum = 0.0;
    var p = 0.0;
    for (final section in data.sections) {
      if (animation.value < pSum) {
        continue;
      }
      pSum += section.value / totalPercentage;

      if (animation.value < pSum) {
        p = (animation.value - (pSum - section.value / totalPercentage)) /
            (section.value / totalPercentage);
      } else {
        p = 1;
      }

      var sweepAngle = 2 * pi * section.value / totalPercentage * p;

      var offset = Offset(
          cos(startAngle + sweepAngle / 2), sin(startAngle + sweepAngle / 2));
      var offsetCenter = center + offset * data.gap;
      var radiusOffset = radius - cos(sweepAngle / 2) * data.gap;
      var sectionControllerValue = section.animation!.value;
      radiusOffset *= 1 + (0.05 * sectionControllerValue);

      final path = Path()
        ..moveTo(offsetCenter.dx, offsetCenter.dy)
        ..arcTo(
          Rect.fromCircle(center: offsetCenter, radius: radiusOffset),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(
        path,
        Paint()
          ..isAntiAlias = true
          ..color = section.color
          ..style = PaintingStyle.fill
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      startAngle += sweepAngle;
    }

    final maskPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: data.innerRadius));

    canvas.drawPath(
      maskPath,
      Paint()
        ..isAntiAlias = true
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    // if (animation.status != AnimationStatus.completed) {
    //   return true;
    // }
    // if (oldDelegate is PieChartPainter) {
    //   for (var i = 0; i < data.sections.length; i++) {
    //     if (data.sections[i].controller!.isAnimating) {
    //       return true;
    //     }
    //   }
    // }
    // return false;
  }
}
