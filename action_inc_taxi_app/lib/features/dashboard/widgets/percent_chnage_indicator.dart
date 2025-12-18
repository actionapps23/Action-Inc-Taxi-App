// ignore_for_file: deprecated_member_use

import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PercentChangeIndicator extends StatelessWidget {
  final double percentChange;
  const PercentChangeIndicator({super.key, required this.percentChange});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = percentChange >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.success.withOpacity(0.15)
            : AppColors.error.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? AppColors.success : AppColors.error,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${percentChange.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              color: isPositive ? AppColors.success : AppColors.error,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
