import 'package:action_inc_taxi_app/core/models/fleet_income_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/features/dashboard/dashboard_cubit.dart';
import 'package:action_inc_taxi_app/features/dashboard/dashboard_state.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/income_bar_chart.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/percent_chnage_indicator.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/pie_chart.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/stats_overview_card.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    final dashboardCubit = context.read<DashboardCubit>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardCubit.fetchTodayBankedAmounts();
      dashboardCubit.fetchFleetAmounts('monthly');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      bloc: context.read<DashboardCubit>(),
      builder: (context, state) {
        final dashboardModel = state.dashboardModel;
        return Scaffold(
          body: state is DashboardLoaded ?  SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Column(
                  children: [
                    Navbar(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacing.vLarge,
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF121212),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 12.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Banked today",
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "₱ ${dashboardModel.totalAmountPaid.toStringAsFixed(2)}",
                                            style: AppTextStyles.bodySmall,
                                          ),
                                          Spacing.hSmall,
                                          PercentChangeIndicator(
                                            percentChange: 12.5,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacing.vExtraLarge,
                                  Text(
                                    "Last day Income ₱ 4,500.00",
                                    style: AppTextStyles.bodyExtraSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacing.vLarge,
                          Row(
                            children: [
                              Expanded(
                                child: SummaryCard(
                                  title: "Total Rent in Cash",
                                  amount: dashboardModel.totalCashAmount,
                                  percentChange: 45,
                                  lastDayAmount: 30000,
                                  lastDayLabel: "lastDayLabel",
                                ),
                              ),
                              Spacing.hSmall,
                              Expanded(
                                child: SummaryCard(
                                  title: "Total Rent in G-Cash",
                                  amount: dashboardModel.totalGCashAmount,
                                  percentChange: 45,
                                  lastDayAmount: 30000,
                                  lastDayLabel: "lastDayLabel",
                                ),
                              ),
                              Spacing.hSmall,
                              Expanded(
                                child: SummaryCard(
                                  title: "Total amount Paid",
                                  amount: dashboardModel.totalAmountPaid,
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
                    ),
                    Spacing.vXXLarge,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: PieChart(fleetIncome: FleetIncomeModel(
                          fleet1Amt: dashboardModel.fleet1Amt,
                          fleet2Amt: dashboardModel.fleet2Amt,
                          fleet3Amt: dashboardModel.fleet3Amt,
                          fleet4Amt: dashboardModel.fleet4Amt,
                          totalFleetAmt: dashboardModel.totalFleetAmt,
                        ),)),
                        Spacing.hMedium,
                        Expanded(
                          child: IncomeBarChart(
                            values: [28000, 17000, 12000, 8000, 1000],
                            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
                            highlightedIndex: 3, // April
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
                            statsCardLabel: "Car Wash Income",
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
                            statsCardLabel: "Maintainence Fees Collected",
                            targetValue: dashboardModel.fleetIncomeTargetValue,
                            optimumTarget: dashboardModel.fleetIncomeOptimumTarget,
                            targetCollection:
                                dashboardModel.fleetIncomeTargetCollection,
                            percentChange: -5.2,
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
          ) : state is DashboardError ? Center(
            child: Text('Error: ${state.message}'),
          ) : Center(
            child: CircularProgressIndicator(),
          ));
      },
    );
  }
}

