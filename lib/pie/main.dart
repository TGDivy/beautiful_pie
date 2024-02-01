import 'dart:math';

import 'package:beautiful_pie/events_chart/data.dart';
import 'package:beautiful_pie/events_chart/painter.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class EventsChart extends StatefulWidget {
  List<Event> data;
  EventsChart({super.key, required this.data});

  @override
  EventsChartState createState() => EventsChartState();
}

class EventsChartState extends State<EventsChart>
    with TickerProviderStateMixin {
  late final AnimationController mainController;
  late final Animation<double> mainAnimation;
  int count = 1;

  @override
  void initState() {
    super.initState();
    mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    mainAnimation = CurvedAnimation(
      parent: mainController,
      curve: Curves.easeInOut,
    );
    mainAnimation.addListener(() {
      setState(() {});
    });
    mainController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => setState(() {
        count++;
      }),
      onTapDown: (TapDownDetails details) {},
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
