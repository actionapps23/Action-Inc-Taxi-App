import 'package:action_inc_taxi_app/core/models/dashboard_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/percent_chnage_indicator.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/pie_chart.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/stats_overview_card.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  final DashboardModel dashboardModel = const DashboardModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              children: [
                Navbar(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacing.vLarge,
                    Text("Total Banked today"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("₱ 5,000.00", style: AppTextStyles.bodySmall),
                            Spacing.hSmall,
                            PercentChangeIndicator(percentChange: 12.5),
                          ],
                        ),
                        // Text("Last day: ₱ 4,500.00", style: AppTextStyles.bodySmall),
                      ],
                    ),
                    Spacing.vMedium,
                    Text(
                      "Last day Income ₱ 4,500.00",
                      style: AppTextStyles.bodyExtraSmall,
                    ),
                    Spacing.vLarge,
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: "Total Rent in Cash",
                            amount: 40000,
                            percentChange: 45,
                            lastDayAmount: 30000,
                            lastDayLabel: "lastDayLabel",
                          ),
                        ),
                        Spacing.hSmall,
                        Expanded(
                          child: SummaryCard(
                            title: "Total Rent in Cash",
                            amount: 40000,
                            percentChange: 45,
                            lastDayAmount: 30000,
                            lastDayLabel: "lastDayLabel",
                          ),
                        ),
                        Spacing.hSmall,
                        Expanded(
                          child: SummaryCard(
                            title: "Total Rent in Cash",
                            amount: 40000,
                            percentChange: 45,
                            lastDayAmount: 30000,
                            lastDayLabel: "lastDayLabel",
                          ),
                        ),
                        Spacing.hSmall,
                      ],
                    ),
                  ],
                ),
                Spacing.vXXLarge,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: PieChart()),
                    Spacing.hMedium,
                    Expanded(child: Container()),
                  ],
                ),
                Spacing.vXXLarge,

                Row(
                  children: [
                    Expanded(
                      child: StatsOverviewCard(
                        statsCardLabel: "Fleet Income",
                        targetValue: dashboardModel.fleetIncomeTargetValue,
                        optimumTarget: dashboardModel.fleetIncomeOptimumTarget,
                        targetCollection:
                            dashboardModel.fleetIncomeTargetCollection,
                        percentChange: 5.2,
                      ),
                    ),
                    Spacing.hMedium,
                    Expanded(
                      child: StatsOverviewCard(
                        statsCardLabel: "Expenses Saved",
                        targetValue: dashboardModel.expensesSavedTargetValue,
                        optimumTarget:
                            dashboardModel.expensesSavedOptimumTarget,
                        targetCollection:
                            dashboardModel.expensesSavedTargetCollection,
                        percentChange: 8.5,
                      ),
                    ),
                  ],
                ),
                Spacing.vXXLarge,
                Row(
                  children: [
                    Expanded(
                      child: StatsOverviewCard(
                        statsCardLabel: "Fleet Income",
                        targetValue: dashboardModel.fleetIncomeTargetValue,
                        optimumTarget: dashboardModel.fleetIncomeOptimumTarget,
                        targetCollection:
                            dashboardModel.fleetIncomeTargetCollection,
                        percentChange: 5.2,
                      ),
                    ),
                    Spacing.hMedium,
                    Expanded(
                      child: StatsOverviewCard(
                        statsCardLabel: "Expenses Saved",
                        targetValue: dashboardModel.expensesSavedTargetValue,
                        optimumTarget:
                            dashboardModel.expensesSavedOptimumTarget,
                        targetCollection:
                            dashboardModel.expensesSavedTargetCollection,
                        percentChange: 8.5,
                      ),
                    ),
                  ],
                ),
                Spacing.vXXLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
