import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ResponsiveText(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
