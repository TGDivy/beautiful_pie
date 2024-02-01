import 'package:flutter/material.dart';

class PieChartData {
  final List<PieSection> sections;
  final bool showLabels;
  final double gap;
  final double innerRadius;
  final Color backgroundCircleColor;

  const PieChartData({
    required this.sections,
    this.showLabels = true,
    this.gap = 5,
    this.innerRadius = 30,
    this.backgroundCircleColor = Colors.blueGrey,
  });

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
      showLabels: showLabels,
      gap: gap,
      innerRadius: innerRadius,
      backgroundCircleColor: backgroundCircleColor,
    );
  }
}

class PieSection {
  final double value;
  final Color color;
  final String label;
  final Offset offset;
  bool selected;
  AnimationController? controller;
  Animation<double>? animation;

  PieSection({
    required this.value,
    required this.color,
    required this.label,
    required this.offset,
    this.selected = false,
    this.controller,
    this.animation,
  });

  PieSection copyWith({
    double? value,
    Color? color,
    String? label,
    Offset? offset,
    bool? selected,
    AnimationController? controller,
    Animation<double>? animation,
  }) {
    return PieSection(
      value: value ?? this.value,
      color: color ?? this.color,
      label: label ?? this.label,
      offset: offset ?? this.offset,
      selected: selected ?? this.selected,
      controller: controller ?? this.controller,
      animation: animation ?? this.animation,
    );
  }
}
