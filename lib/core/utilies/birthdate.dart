class Birthdate {
  static DateTime? parse(Object? value) {
    if (value is DateTime) {
      return DateTime(value.year, value.month, value.day);
    }
    if (value is! String) return null;

    final text = value.trim();
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})(?:T.*)?$').firstMatch(text);
    if (match == null || DateTime.tryParse(text) == null) return null;

    // Keep the calendar date even when the response includes a time zone.
    final year = int.parse(match[1]!);
    final month = int.parse(match[2]!);
    final day = int.parse(match[3]!);
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  static String toDisplay(DateTime? value) {
    if (value == null) return '';
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String toJson(DateTime value) => '${toDisplay(value)}T00:00:00';
}
