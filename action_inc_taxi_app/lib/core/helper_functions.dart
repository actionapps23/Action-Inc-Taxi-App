import 'package:flutter/material.dart';

class HelperFunctions {
  // Time and Date related helpers
  static int utcFromController(TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isEmpty) return 0;
    DateTime? date = DateTime.tryParse(text);
    if (date == null) {
      try {
        final parts = text.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            date = DateTime(year, month, day);
          }
        }
      } catch (_) {}
    }
    if (date == null) {
      // Try dd MMM, yyyy
      try {
        final reg = RegExp(r'^(\d{1,2}) ([A-Za-z]{3}), (\d{4})$');
        final match = reg.firstMatch(text);
        if (match != null) {
          final day = int.tryParse(match.group(1)!);
          final monthStr = match.group(2)!;
          final year = int.tryParse(match.group(3)!);
          final months = {
            'Jan': 1,
            'Feb': 2,
            'Mar': 3,
            'Apr': 4,
            'May': 5,
            'Jun': 6,
            'Jul': 7,
            'Aug': 8,
            'Sep': 9,
            'Oct': 10,
            'Nov': 11,
            'Dec': 12,
          };
          final month = months[monthStr];
          if (day != null && month != null && year != null) {
            date = DateTime(year, month, day);
          }
        }
      } catch (_) {}
    }
    if (date == null) return 0;
    return date.toUtc().millisecondsSinceEpoch;
  }

  static int currentUtcTimeMilliSeconds() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  static DateTime addMonths(DateTime start, int months) {
    int newYear = start.year + ((start.month - 1 + months) ~/ 12);
    int newMonth = ((start.month - 1 + months) % 12) + 1;
    int newDay = start.day;
    int lastDayOfMonth = DateTime.utc(newYear, newMonth + 1, 0).day;
    if (newDay > lastDayOfMonth) newDay = lastDayOfMonth;
    return DateTime.utc(newYear, newMonth, newDay);
  }

  static getDateTimeFromUtcMilliSeconds(int utcMs) {
    return DateTime.fromMillisecondsSinceEpoch(utcMs, isUtc: true);
  }

  static String generateDateKeyFromUtc(int utcMillis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(utcMillis, isUtc: true);
    final year = dt.year.toString();
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '$year-$month-$day'; // e.g., "2025-12-20"
  }
}
