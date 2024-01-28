import 'dart:math';
import 'package:beautiful_pie/pie/data.dart';
import 'package:beautiful_pie/pie/painter.dart';
import 'package:flutter/material.dart';

// Animated Pie Chart class that manages the state of the Pie Chart Data.
class AnimatedPieChart extends StatefulWidget {
  final PieChartData data;
  const AnimatedPieChart({super.key, required this.data});
  // const AnimatedPieChart({Key? key}) : super(key: key);
  // data is input

  @override
  AnimatedPieChartState createState() => AnimatedPieChartState();
}

class AnimatedPieChartState extends State<AnimatedPieChart>
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
    _data = widget.data;

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
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () => addSection(
                  PieSection(
                    value: 0.25,
                    color: [
                      Colors.blue,
                      Colors.green,
                      Colors.red,
                    ][Random().nextInt(19)],
                    label: 'Red',
                    offset: const Offset(0, 0),
                  ),
                ),
              )
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
      _data = _data.copyWith(sections: [..._data.sections, section]);
    });

    _controller.reset();
    _controller.forward();
  }
}
