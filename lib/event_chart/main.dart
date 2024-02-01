import 'package:beautiful_pie/event_chart/data.dart';
import 'package:beautiful_pie/event_chart/painter.dart';
import 'package:flutter/material.dart';

class EventsChart extends StatefulWidget {
  final List<Event> events;
  const EventsChart({super.key, required this.events});

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
        painter: EventsChartPainter(),
        // child: Center(
        //   child: Text(
        //     count.toString(),
        //     style: const TextStyle(
        //       fontSize: 28,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  @override
  void dispose() {
    mainController.dispose();
    super.dispose();
  }
}
