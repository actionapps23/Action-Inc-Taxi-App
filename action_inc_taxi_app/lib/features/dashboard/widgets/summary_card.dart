// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/percent_chnage_indicator.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int amount;
  final int? lastDayAmount;
  final String? lastDayLabel;
  final String currencySymbol;
  final IconData icon;
  final VoidCallback? onPressed;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    this.lastDayAmount,
    this.lastDayLabel,
    this.currencySymbol = '₱',
    this.onPressed,
    this.icon = Icons.account_balance_wallet_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ResponsiveText(
                  title,
                  style: const TextStyle(
                    color: AppColors.scaffold,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(max(2.w, 4.h)),
                  decoration: BoxDecoration(
                    color: AppColors.scaffold.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      icon,
                      color: AppColors.scaffold,
                      size: max(8.w, 12),
                    ),
                    onPressed: onPressed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ResponsiveText(
                '$currencySymbol ${_formatNumber(amount)}',
                style: AppTextStyles.bodySmall,
              ),
              Spacing.hSmall,
              if (lastDayAmount != null) ...[
                Flexible(
                  child: PercentChangeIndicator(
                    percentChange: HelperFunctions.percentChange(
                      lastDayAmount!,
                      amount,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (lastDayLabel != null)
            ResponsiveText(
              '$lastDayLabel',
              style: const TextStyle(
                color: AppColors.scaffold,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          if (lastDayLabel == null && lastDayAmount != null)
            ResponsiveText(
              '$lastDayLabel: $currencySymbol ${_formatNumber(lastDayAmount!)}',
              style: const TextStyle(
                color: AppColors.scaffold,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}
