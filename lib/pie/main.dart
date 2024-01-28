import 'dart:math';
import 'package:flutter/material.dart';

class PieChartData {
  final List<PieSection> sections;

  const PieChartData({required this.sections});

  @override
  String toString() => 'PieChartData(sections: $sections)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PieChartData && listEquals(other.sections, sections);
  }

  @override
  int get hashCode => sections.hashCode;

  listEquals(List<PieSection> a, List<PieSection> b) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }

  PieChartData copyWith({
    List<PieSection>? sections,
  }) {
    return PieChartData(
      sections: sections ?? this.sections,
    );
  }
}

class PieSection {
  final double value;
  final Color color;
  final Border border;
  final String label;
  final Offset offset;
  final Widget widget;

  const PieSection({
    required this.value,
    required this.color,
    required this.border,
    required this.label,
    required this.offset,
    required this.widget,
  });

  @override
  String toString() {
    return 'PieSection(percentage: $value, color: $color, border: $border, label: $label, offset: $offset, widget: $widget)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PieSection &&
        other.value == value &&
        other.color == color &&
        other.border == border &&
        other.label == label &&
        other.offset == offset &&
        other.widget == widget;
  }

  @override
  int get hashCode {
    return value.hashCode ^
        color.hashCode ^
        border.hashCode ^
        label.hashCode ^
        offset.hashCode ^
        widget.hashCode;
  }

  PieSection copyWith({
    double? value,
    Color? color,
    Border? border,
    String? label,
    Offset? offset,
    Widget? widget,
  }) {
    return PieSection(
      value: value ?? this.value,
      color: color ?? this.color,
      border: border ?? this.border,
      label: label ?? this.label,
      offset: offset ?? this.offset,
      widget: widget ?? this.widget,
    );
  }
}

// input is a `PieChartData` object and the output is a `CustomPainter` object.
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
      final sweepAngle = 2 * pi * section.value / totalPercentage * p;

      // The next step is to create a `Path` object.
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      // The next step is to draw the section.
      canvas.drawPath(
        path,
        Paint()
          ..color = section.color
          ..style = PaintingStyle.fill
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      // The next step is to draw the border of the section.
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      // The next step is to update the start angle.
      startAngle += sweepAngle;
    }
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

// Animated Pie Chart class that manages the state of the Pie Chart Data.
class AnimatedPieChart extends StatefulWidget {
  const AnimatedPieChart({Key? key}) : super(key: key);

  @override
  _AnimatedPieChartState createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late PieChartData _data;

  @override
  void initState() {
    super.initState();

    // The first step is to initialize the animation controller.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // The next step is to initialize the animation.
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // The next step is to initialize the data.
    _data = PieChartData(
      sections: [
        PieSection(
          value: 0.25,
          color: Colors.blue,
          border: Border.all(color: Colors.black, width: 2),
          label: 'Red',
          offset: const Offset(0, 0),
          widget: const Text('Red'),
        ),
        PieSection(
          value: 0.25,
          color: Colors.green,
          border: Border.all(color: Colors.black, width: 2),
          label: 'Green',
          offset: const Offset(0, 0),
          widget: const Text('Green'),
        ),
        PieSection(
          value: 0.5,
          color: Colors.red,
          border: Border.all(color: Colors.black, width: 2),
          label: 'Blue',
          offset: const Offset(0, 0),
          widget: const Text('Blue'),
        ),
      ],
    );

    // The next step is to start the animation.
    _controller.forward();
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

    return CustomPaint(
      painter: PieChartPainter(data: newData, animation: _animation),
      child: SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                  onPressed: () => addSection(PieSection(
                        value: 0.25,
                        color: Colors.red,
                        border: Border.all(color: Colors.black, width: 2),
                        label: 'Red',
                        offset: const Offset(0, 0),
                        widget: const Text('Red'),
                      )),
                  child: const Text('Add')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The next step is to add a method to update the data.
  void updateData(PieChartData data) {
    setState(() {
      _data = data;
    });
  }

  // The next step is to add a method to add a section.
  void addSection(PieSection section) {
    setState(() {
      _data = PieChartData(
        sections: [..._data.sections, section],
      );
    });

    _controller.reset();
    _controller.forward();
  }
}
