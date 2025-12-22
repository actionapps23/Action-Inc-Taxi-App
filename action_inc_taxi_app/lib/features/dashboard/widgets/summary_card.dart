// ignore_for_file: deprecated_member_use

import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/percent_chnage_indicator.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int amount;
  final int lastDayAmount;
  final String lastDayLabel;
  final String currencySymbol;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.lastDayAmount,
    required this.lastDayLabel,
    this.currencySymbol = '₱',
    this.icon = Icons.account_balance_wallet_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.scaffold,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.scaffold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.scaffold, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$currencySymbol ${_formatNumber(amount)}',
                style: AppTextStyles.bodySmall,
              ),
              Spacing.hSmall,
              PercentChangeIndicator(
                percentChange: HelperFunctions.percentChange(
                  lastDayAmount,
                  amount,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$lastDayLabel: $currencySymbol ${_formatNumber(lastDayAmount)}',
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
