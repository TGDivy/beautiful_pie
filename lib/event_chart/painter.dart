import 'dart:math';

import 'package:beautiful_pie/event_chart/data.dart';
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

// construct an event tree
class EventTree {
  final Event event;
  final List<EventTree> children = [];

  EventTree(this.event);

  void add(EventTree child) {
    children.add(child);
  }
}

// construct a tree of events
EventTree buildEventTree(List<Event> events) {
  // sort the events by start time
  events.sort((a, b) => a.time.compareTo(b.time));

  // create a tree of events
  var root = EventTree(events[0]);
  var current = root;
  for (var i = 1; i < events.length; i++) {
    var event = events[i];
    if (event.time.isAfter(current.event.time.add(event.duration))) {
      // create a new root
      current = root;
    }
    var child = EventTree(event);
    current.add(child);
    current = child;
  }
  return root;
}

// calculate the max number of rings
int maxIntersectingEvents(EventTree root) {
  var max = 0;
  for (var child in root.children) {
    var count = maxIntersectingEvents(child);
    if (count > max) {
      max = count;
    }
  }
  return max + 1;
}

class EventsChartPainter extends CustomPainter {
  final List<Event> events;
  final Animation<double> animation;

  const EventsChartPainter({required this.events, required this.animation})
      : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;

    final clockRadius = 2 * maxRadius / 3;
    paintClock(canvas, center, clockRadius);

    final maxRings = 3; //maxIntersectingEvents(buildEventTree(events));
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
