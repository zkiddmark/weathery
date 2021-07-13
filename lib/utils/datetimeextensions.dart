extension DateTimeExtensions on DateTime {
  static DateTime fromUnixTimeStampToUtc(int value) {
    return DateTime.fromMillisecondsSinceEpoch(value * 1000).toUtc();
  }
}
