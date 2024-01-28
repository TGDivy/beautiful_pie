import 'dart:ui';

class PieChartData {
  final List<PieSection> sections;
  final bool showLabels;
  final double gap;
  final double innerRadius;

  const PieChartData({
    required this.sections,
    this.showLabels = true,
    this.gap = 5,
    this.innerRadius = 25,
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
    );
  }
}

class PieSection {
  final double value;
  final Color color;
  final String label;
  final Offset offset;
  final bool selected;

  const PieSection({
    required this.value,
    required this.color,
    required this.label,
    required this.offset,
    this.selected = false,
  });

  PieSection copyWith({
    double? value,
    Color? color,
    String? label,
    Offset? offset,
    bool? selected,
  }) {
    return PieSection(
      value: value ?? this.value,
      color: color ?? this.color,
      label: label ?? this.label,
      offset: offset ?? this.offset,
      selected: selected ?? this.selected,
    );
  }
}
