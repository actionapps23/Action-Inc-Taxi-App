// ignore_for_file: deprecated_member_use

import 'package:action_inc_taxi_app/features/dashboard/widgets/percent_chnage_indicator.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';

class SimpleStatCard extends StatelessWidget {
  final String label;
  final int value;
  final double? percentChange;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? valueColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final String currencySymbol;

  const SimpleStatCard({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.percentChange,
    this.labelColor,
    this.valueColor,
    this.borderRadius = 16,
    this.padding,
    this.currencySymbol = '₱',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.buttonText,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (percentChange != null)
                PercentChangeIndicator(percentChange: percentChange!),
            ],
          ),
          Text(
            label,
            style: TextStyle(
              color: labelColor ?? AppColors.scaffold.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${value.toString()} $currencySymbol',
            style: TextStyle(
              color: valueColor ?? AppColors.scaffold,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
