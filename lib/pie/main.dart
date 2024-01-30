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
    _animation.addListener(() {
      setState(() {});
    });
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
      section.animation!.addListener(() {
        setState(() {});
      });

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
                color: Color.lerp(e.color, colorScheme.primary, 0.3)))
            .toList());
    final totalPercentage = _data.sections.fold(0.0, (sum, e) => sum + e.value);

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        // using global key and render box to get the position of tap relative to the center of the pie chart
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset localOffset = box.globalToLocal(details.globalPosition);
        final Offset center = Offset(box.size.width / 2, box.size.height / 2);
        final Offset offset = localOffset - center;
        const double diff = 0;
        double angle = atan2(offset.dy, offset.dx) + pi / 2;
        double startAngle = diff;
        if (angle < 0) {
          angle += 2 * pi;
        }
        final newSections = <PieSection>[];
        for (var i = 0; i < _data.sections.length; i++) {
          final section = _data.sections[i];
          final sweepAngle = 2 * pi * section.value / totalPercentage;
          if (section.selected) {
            newSections.add(section.copyWith(selected: false));
          } else if (startAngle <= angle && angle <= startAngle + sweepAngle) {
            newSections.add(section.copyWith(selected: true));
          } else {
            newSections.add(section.copyWith(selected: false));
          }
          startAngle += sweepAngle;
        }

        setState(() {
          count++;
          _data = _data.copyWith(sections: newSections);
          for (var section in _data.sections) {
            if (section.selected) {
              section.controller!.forward();
            } else {
              section.controller!.reverse();
            }
          }
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
