import 'dart:math';

import 'package:beautiful_pie/pie/data.dart';
import 'package:beautiful_pie/pie/painter.dart';
import 'package:flutter/material.dart';

class AnimatedPieChart extends StatefulWidget {
  final PieChartData data;
  const AnimatedPieChart({super.key, required this.data});

  @override
  AnimatedPieChartState createState() => AnimatedPieChartState();
}

class AnimatedPieChartState extends State<AnimatedPieChart>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late PieChartData _data;
  int count = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    _data = widget.data;
    for (var section in _data.sections) {
      section.controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      section.animation = CurvedAnimation(
        parent: section.controller!,
        curve: Curves.easeInOut,
      );

      if (section.selected) {
        section.controller!.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    // lerp the colors of data with colorScheme
    final newData = _data.copyWith(
        sections: _data.sections
            .map((e) => e.copyWith(
                color: Color.lerp(e.color, colorScheme.primaryContainer, 0.33)))
            .toList());
    final totalPercentage =
        newData.sections.fold(0.0, (sum, e) => sum + e.value);

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset localOffset = box.globalToLocal(details.globalPosition);
        final double dx = localOffset.dx - box.size.width / 2;
        final double dy = localOffset.dy - box.size.height / 2;
        final double angle = atan2(dy, dx);
        double startAngle = -pi / 2;

        final newSections = <PieSection>[];
        for (var i = 0; i < _data.sections.length; i++) {
          final section = _data.sections[i];
          final sweepAngle = 2 * pi * section.value / totalPercentage;
          if (section.selected) {
            newSections.add(section.copyWith(selected: false));
            section.controller!.reverse();
          } else if (startAngle <= angle && angle <= startAngle + sweepAngle) {
            newSections.add(section.copyWith(selected: true));
            section.controller!.reset();
            section.controller!.forward();
          } else {
            newSections.add(section.copyWith(selected: false));
            section.controller!.reverse();
          }
          startAngle += sweepAngle;
        }

        setState(() {
          count++;
          _data = _data.copyWith(sections: newSections);
        });
      },
      child: CustomPaint(
          painter: PieChartPainter(data: newData, animation: _animation),
          child: Center(
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var section in _data.sections) {
      section.controller!.dispose();
    }
    super.dispose();
  }
}
