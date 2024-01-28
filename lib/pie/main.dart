import 'dart:math';

import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height),
      0,
      2 * pi, // Draws 2/3 of the circle
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PieChart extends StatelessWidget {
  const PieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PieChartPainter(),
    );
  }
}
