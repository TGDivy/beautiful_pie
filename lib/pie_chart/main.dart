import 'dart:math';

import 'package:beautiful_pie/pie_chart/painter.dart';
import 'package:beautiful_pie/pie_chart/data.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

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
    final totalPercentage = _data.sections.fold(0.0, (sum, e) => sum + e.value);

    return GestureDetector(
      onPanUpdate: (details) => setState(() {
        count++;
      }),
      onTapDown: (TapDownDetails details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        if (isInsideBoxCircle(box, details.globalPosition, _data.innerRadius)) {
          return;
        }
        bool isSelected(double startAngle, double sweepAngle, double angle) {
          return startAngle <= angle && angle <= startAngle + sweepAngle;
        }

        final double angle = findAngle(box, details.globalPosition);
        double startAngle = 0;
        final newSections = _data.sections.asMap().entries.map((entry) {
          final section = entry.value;
          final sweepAngle = 2 * pi * section.value / totalPercentage;
          bool selected = isSelected(startAngle, sweepAngle, angle);
          if (section.selected) {
            selected = false;
          }
          startAngle += sweepAngle;
          if (selected) {
            section.controller!.forward();
          } else {
            section.controller!.reverse();
          }
          return section.copyWith(selected: selected);
        }).toList();

        setState(() {
          count++;
          _data = _data.copyWith(sections: newSections);
        });
      },
      child: CustomPaint(
          painter: PieChartPainter(data: _data, animation: _animation),
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
