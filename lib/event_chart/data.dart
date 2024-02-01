import 'dart:ui';

import 'package:flutter/material.dart';

class Event {
  final String title;
  final DateTime time;
  final Duration duration;
  final Color color;
  final String? location;
  final String? description;
  final String? type;

  const Event({
    required this.title,
    required this.time,
    required this.duration,
    required this.color,
    this.location,
    this.description,
    this.type,
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
