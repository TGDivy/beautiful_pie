// input is a `PieChartData` object and the output is a `CustomPainter` object.
import 'dart:math';

import 'package:beautiful_pie/pie/data.dart';
import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  final PieChartData data;
  final Animation<double> animation;

  const PieChartPainter({required this.data, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // The first step is to calculate the total percentage of the pie chart.
    final totalPercentage = data.sections.fold<double>(
      0,
      (previousValue, element) => previousValue + element.value,
    );

    // The next step is to calculate the radius of the pie chart.
    final radius = min(size.width, size.height) / 2;

    // The next step is to calculate the center of the pie chart.
    final center = Offset(size.width / 2, size.height / 2);

    // The next step is to calculate the angle of the first section.
    var startAngle = -pi / 2;

    var pSum = 0.0;
    var p = 0.0;
    // The next step is to iterate over the sections and draw each section.
    for (final section in data.sections) {
      // If the animation has not reached this section yet, skip it
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

      // The first step is to calculate the sweep angle of the section.
      var sweepAngle = 2 * pi * section.value / totalPercentage * p;

      // Create a gap effect between sections, we need move the start angle, sweep angle and center
      // to create a gap effect.

      var offset = Offset(
          cos(startAngle + sweepAngle / 2), sin(startAngle + sweepAngle / 2));
      var offsetCenter = center + offset * data.gap;

      // using the angle, we can calculate the radius offset
      var radiusOffset = radius - cos(sweepAngle / 2) * data.gap;

      // The next step is to create a `Path` object.
      final path = Path()
        ..moveTo(offsetCenter.dx, offsetCenter.dy)
        ..arcTo(
          Rect.fromCircle(
              center: offsetCenter,
              radius: radiusOffset * (section.selected ? 1.05 : 1.0)),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      // The next step is to draw the section.
      canvas.drawPath(
        path,
        Paint()
          ..isAntiAlias = true
          ..color = section.color
          ..style = PaintingStyle.fill
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      // The next step is to update the start angle.
      startAngle += sweepAngle;
    }

    // The next step is to add a mask to the pie chart, in the center of the pie chart.
    final maskPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: data.innerRadius));

    // The next step is to draw the mask.
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
    if (animation.status != AnimationStatus.completed) {
      return true;
    } else {
      return false;
    }
  }
}
