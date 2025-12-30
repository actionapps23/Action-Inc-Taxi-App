import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/enums.dart';
import 'package:flutter/material.dart';

class HelperFunctions {
  static double getChildAspectRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 400) {
      return 1;
    } else if (width < 800) {
      return 2.0;
    } else {
      return 2.5;
    }
  }

  static double percentChange(num previous, num current) {
    if (previous == 0) {
      return 0;
    }
    return ((current - previous) / previous) * 100;
  }

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

  static String formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')} ${AppConstants.monthNames[d.month - 1]} ${d.year}';
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

  static String formatDateFromUtcMillis(int? utcMillis) {
    if (utcMillis == null || utcMillis == 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(utcMillis, isUtc: true);
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    return '$day/$month/$year';
  }

  static InventoryStatus inventoryStatusFromString(String status) {
    switch (status) {
      case "inStock":
        return InventoryStatus.inStock;
      case "lowStock":
        return InventoryStatus.lowStock;
      case "outOfStock":
        return InventoryStatus.outOfStock;
      default:
        return InventoryStatus.ordered;
    }
  }

  static String stringFromInventoryStatus(InventoryStatus status) {
    switch (status) {
      case InventoryStatus.inStock:
        return "In Stock";
      case InventoryStatus.lowStock:
        return "Low Stock";
      case InventoryStatus.outOfStock:
        return "Out of Stock";
      case InventoryStatus.ordered:
        return "Ordered";
    }
  }

  static String timeDifferenceFromNow(DateTime past) {
    final now = DateTime.now();
    final difference = now.difference(past);

    if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  static String monthIntToString(int month) {
    if (month < 1 || month > 12) return '';
    return AppConstants.monthNames[month - 1];
  }

  static getKeyFromTitle(String title) {
    return title.toLowerCase().replaceAll(' ', '_');
  }

  static getTitleFromKey(String key) {
    return key
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }

  static DateTime? parseDateString(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
