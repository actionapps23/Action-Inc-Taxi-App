import 'package:flutter/material.dart';

class HelperFunctions {
  static int utcFromController(TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isEmpty) return 0;
    final date = DateTime.tryParse(text);
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
}