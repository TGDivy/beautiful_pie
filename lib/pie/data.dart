import 'dart:ui';

import 'package:flutter/material.dart';

class Event {
  final String title;
  final DateTime time;
  final Duration duration;
  final Color color;
  final String location;
  final String description;
  final String type;

  const Event({
    required this.title,
    required this.time,
    required this.duration,
    required this.color,
    required this.location,
    required this.description,
    required this.type,
  });

  Event copyWith({
    String? title,
    DateTime? time,
    Duration? duration,
    Color? color,
    String? location,
    String? description,
    String? type,
  }) {
    return Event(
      title: title ?? this.title,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      color: color ?? this.color,
      location: location ?? this.location,
      description: description ?? this.description,
      type: type ?? this.type,
    );
  }
}

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
