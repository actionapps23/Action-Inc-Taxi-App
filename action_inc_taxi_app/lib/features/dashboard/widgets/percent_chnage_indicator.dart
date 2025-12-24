// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PercentChangeIndicator extends StatelessWidget {
  final double percentChange;
  const PercentChangeIndicator({super.key, required this.percentChange});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = percentChange >= 0;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isPositive
              ? AppColors.success.withOpacity(0.15)
              : AppColors.error.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: isPositive ? AppColors.success : AppColors.error,
              size: min(6.w, 12),
            ),
            SizedBox(width: 2),
            Flexible(
              child: ResponsiveText(
                '${percentChange.abs().toStringAsFixed(2)}%',
                style: TextStyle(
                  color: isPositive ? AppColors.success : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
