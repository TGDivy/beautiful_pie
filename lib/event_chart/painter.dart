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

int maxIntersectingEventsAtSingleTime(List<Event> events) {
  events.sort((a, b) => a.time.compareTo(b.time));

  List<Event> intersectingEvents = [];

  var maxIntersectingEvents = 0;
  for (var event in events) {
    intersectingEvents
        .removeWhere((e) => e.time.add(e.duration).compareTo(event.time) <= 0);
    intersectingEvents.add(event);
    maxIntersectingEvents =
        max(maxIntersectingEvents, intersectingEvents.length);
  }

  return maxIntersectingEvents;
}

void PaintCurvedLabel(Canvas canvas, Offset center, String label, double angle,
    double radius, double offset, TextStyle style) {
  angle += startAngle;
  // given the angle, find the x and y coordinates of the center of the label
  // then iterate through the characters of the label and draw them one by one
  // if top half, draw from the center to the right
  // if bottom half, draw from the center to the left

  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: style,
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  final labelRadius = radius + offset;
  final labelCenter = Offset(
    center.dx + labelRadius * cos(angle),
    center.dy + labelRadius * sin(angle),
  );

  final labelWidth = textPainter.width;
  final labelHeight = textPainter.height;

  final labelStart = Offset(
    labelCenter.dx - labelWidth / 2,
    labelCenter.dy - labelHeight / 2,
  );

  for (var i = 0; i < label.length; i++) {
    final char = label[i];

    //using angle, find the x and y coordinates of the center of the label
    final charStart = Offset(
      labelStart.dx + i * textPainter.width / label.length + i * 5,
      labelStart.dy,
    );

    final charPainter = TextPainter(
      text: TextSpan(
        text: char,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    );

    charPainter.layout();
    charPainter.paint(canvas, charStart);
  }
}

void paintEvents(Canvas canvas, List<Event> events, Offset center,
    List<double> rings, double ringWidth) {
  events.sort((a, b) => a.time.compareTo(b.time));
  Map<int, List<Event>> intersectingEvents = {};
  for (var event in events) {
    // remove events that have already ended
    intersectingEvents.removeWhere((key, value) =>
        value[0].time.add(value[0].duration).compareTo(event.time) <= 0);

    // find the first ring that doesn't intersect with any of the intersecting events
    var ringIndex = 0;
    for (var i = 0; i < rings.length; i++) {
      if (!intersectingEvents.containsKey(i)) {
        ringIndex = i;
        break;
      }
    }

    // get the angle and sweep angle
    final angle = event.time.hour * 2 * pi / 24;
    final sweepAngle = event.duration.inHours * 2 * pi / 24;

    // paint the event
    paintRingSection(canvas, center, angle, sweepAngle, event.color,
        rings[ringIndex], ringWidth);

    // paint the label
    final labelRadius = rings[ringIndex];
    const labelStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    PaintCurvedLabel(canvas, center, event.title, angle + sweepAngle / 2,
        labelRadius, 0, labelStyle);

    // add the event to the intersecting events
    intersectingEvents[ringIndex] = [event];
  }
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

    // final eventTree = buildEventTree(events);
    final maxRings = maxIntersectingEventsAtSingleTime(events);
    // print(maxRings);
    const ringGap = 2;
    final ringWidth = (maxRadius - clockRadius - ringGap * maxRings) / maxRings;

    List<double> rings = [];
    for (var i = 0; i < maxRings; i++) {
      final r = clockRadius + ringGap * (i + 1) + (i * 2 + 1) * ringWidth / 2;
      rings.add(r);
    }

    // sample paint
    // paintRingSection(
    //     canvas, center, 0, pi / 2, Colors.red, rings[0], ringWidth);
    // paintRingSection(
    //     canvas, center, pi / 8, pi / 3, Colors.red, rings[1], ringWidth);
    // paintRingSection(
    //     canvas, center, pi / 4, pi, Colors.red, rings[2], ringWidth);

    // paint the events
    paintEvents(canvas, events, center, rings, ringWidth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
