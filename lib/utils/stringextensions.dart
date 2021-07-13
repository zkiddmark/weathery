extension StringExtensions on String {
  double parseTemp() {
    return double.tryParse(this) ?? 0.0;
  }
}
