import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/simple_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsOverviewCard extends StatefulWidget {
  final String statsCardLabel;
  final int targetValue;
  final int optimumTarget;
  final int targetCollection;
  final int? lastAmount;
  final double percentChange;
  final Function(int) onTabSelected;

  const StatsOverviewCard({
    super.key,
    required this.statsCardLabel,
    required this.targetValue,
    required this.optimumTarget,
    required this.targetCollection,
    required this.percentChange,
    required this.onTabSelected,
    this.lastAmount,
  });

  @override
  State<StatsOverviewCard> createState() => _StatsOverviewCardState();
}

class _StatsOverviewCardState extends State<StatsOverviewCard> {
  int selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181917),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 80.w,
                  child: ResponsiveText(
                    widget.statsCardLabel,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                Flexible(
                  child: CustomTabBar(
                    selectedTabIndex: selectedTabIndex,
                    backgroundColor: AppColors.buttonText,
                    tabs: ["Daily", "Weekly", "Monthly"],
                    onTabSelected: (index) {
                      setState(() {
                        selectedTabIndex = index;
                      });
                        widget.onTabSelected(index);
                    },
                  ),
                ),
              ],
            ),
            Spacing.vMedium,
            Row(
              children: [
                Expanded(
                  child: SimpleStatCard(label: "Target", value: widget.targetValue),
                ),
                Spacing.hSmall,
                Expanded(
                  child: SimpleStatCard(
                    label: "Optimum target",
                    value: widget.optimumTarget,
                  ),
                ),
                Spacing.hSmall,
                Expanded(
                  child: SimpleStatCard(
                    label: "Target collection",
                    value: widget.targetCollection,
                    percentChange: widget.percentChange,
                    showLastStats: true,
                    lastAmount: widget.lastAmount,
                  ),
                ),
              ],
            ),
            Spacing.vSmall,
          ],
        ),
      ),
    );
  }
}
