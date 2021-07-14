import 'dart:collection';

extension StringExtensions on String {
  double parseTemp() {
    return double.tryParse(this) ?? 0.0;
  }

  String formatCelcius() {
    return this + '\u2103';
  }
}
