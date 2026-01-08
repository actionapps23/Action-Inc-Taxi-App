import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/fleet_income_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/features/dashboard/dashboard_cubit.dart';
import 'package:action_inc_taxi_app/features/dashboard/dashboard_state.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/income_bar_chart.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/pie_chart.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/stats_overview_card.dart';
import 'package:action_inc_taxi_app/features/dashboard/widgets/summary_card.dart';
import 'package:action_inc_taxi_app/features/purchase/edit_popup.dart';
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
      dashboardCubit.fetchFleetAmounts('daily');
      dashboardCubit.fetchMaintainanceCollectionAmount('daily');
      dashboardCubit.fetchcarWashCollectionAmount('daily');
      dashboardCubit.getFleetIncomeForYear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();
    return BlocBuilder<DashboardCubit, DashboardState>(
      bloc: dashboardCubit,
      builder: (context, state) {
        final dashboardModel = state.dashboardModel;
        return Scaffold(
          body: state is DashboardLoaded
              ? SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        children: [
                          Navbar(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0.w,
                              vertical: 0.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Spacing.vLarge,
                               SummaryCard(title: "Total Banked today", amount: dashboardModel.totalAmountPaidToday, lastDayLabel: "Note: Please note that this is manual entry and not persisted in database", icon: Icons.edit, onPressed: () {
                                 showDialog(context: context, builder: (context){
                                  return EditFieldPopup(title: "Udpate Amount", label: "Total Banked today", initialValue: dashboardModel.totalAmountPaidToday.toString(), hintText: "Enter new amount", onSave: (newAmt){
                                    dashboardCubit.updateTodayBankedAmount(int.parse(newAmt));
                                  });

                                 });
                               },),
                                Spacing.vLarge,
                                Row(
                                  children: [
                                    Expanded(
                                      child: SummaryCard(
                                        title: "Total Rent in Cash",
                                        amount:
                                            dashboardModel.totalCashAmountToday,
                                        lastDayAmount: dashboardModel
                                            .totalCashAmountYesterday,
                                        lastDayLabel: "Last Day Amount",
                                      ),
                                    ),
                                    Spacing.hSmall,
                                    Expanded(
                                      child: SummaryCard(
                                        title: "Total Rent in G-Cash",
                                        amount: dashboardModel
                                            .totalGCashAmountToday,
                                        lastDayAmount: dashboardModel
                                            .totalGCashAmountYesterday,
                                        lastDayLabel: "Last Day Amount",
                                      ),
                                    ),
                                    Spacing.hSmall,
                                    Expanded(
                                      child: SummaryCard(
                                        title: "Total amount Paid",
                                        amount:
                                            dashboardModel.totalAmountPaidToday,
                                        lastDayAmount:
                                            dashboardModel.totalAmountYesterday,
                                        lastDayLabel: "Last Day Amount",
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
                              Expanded(
                                child: PieChart(
                                  fleetIncome: FleetIncomeModel(
                                    fleet1Amt: dashboardModel.fleet1Amt,
                                    fleet2Amt: dashboardModel.fleet2Amt,
                                    fleet3Amt: dashboardModel.fleet3Amt,
                                    fleet4Amt: dashboardModel.fleet4Amt,
                                    totalFleetAmtForChart: dashboardModel.totalFleetAmtForChart,
                                    totalFleetAmtForStatsCard: dashboardModel.totalFleetAmtForStatsCard,
                                  ),
                                ),
                              ),
                              Spacing.hMedium,
                              Expanded(
                                child: IncomeBarChart(
                                  values: dashboardModel.monthlyFleetIncomes,
                                  labels: AppConstants.monthNames.sublist(
                                    0,
                                    dashboardModel.monthlyFleetIncomes.length,
                                  ),
                                  highlightedIndex: 0, // April
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
                                  targetValue:
                                      0,
                                  optimumTarget:
                                      0,
                                  targetCollection:
                                      dashboardModel.totalFleetAmtForStatsCard,
                                  percentChange: HelperFunctions.percentChange(
                                    dashboardModel.fleetIncomePreviousPeriod,
                                    dashboardModel.totalFleetAmtForStatsCard,
                                  ),
                                  lastAmount:
                                      dashboardModel.fleetIncomePreviousPeriod,
                                  onTabSelected: (value) {
                                    if (value == 0) {
                                      dashboardCubit.fetchFleetAmounts('daily');
                                    } else if (value == 1) {
                                      dashboardCubit.fetchFleetAmounts(
                                        'weekly',
                                      );
                                    } else if (value == 2) {
                                      dashboardCubit.fetchFleetAmounts(
                                        'monthly',
                                      );
                                    }
                                  },
                                ),
                              ),
                              Spacing.hMedium,
                              Expanded(
                                child: StatsOverviewCard(
                                  statsCardLabel: "Car Wash Income",
                                  targetValue:
                                      dashboardModel.washIncomeTargetValue,
                                  optimumTarget:
                                      dashboardModel.washIncomeOptimumTarget,
                                  targetCollection:
                                      dashboardModel.totalCarWashFeesToday,
                                  percentChange: HelperFunctions.percentChange(
                                    dashboardModel.totalCarWashFeesYesterday,
                                    dashboardModel.totalCarWashFeesToday,
                                  ),
                                  lastAmount:
                                      dashboardModel.totalCarWashFeesYesterday,
                                  onTabSelected: (value) {
                                    if (value == 0) {
                                      dashboardCubit
                                          .fetchcarWashCollectionAmount(
                                            'daily',
                                          );
                                    } else if (value == 1) {
                                      dashboardCubit
                                          .fetchcarWashCollectionAmount(
                                            'weekly',
                                          );
                                    } else if (value == 2) {
                                      dashboardCubit
                                          .fetchcarWashCollectionAmount(
                                            'monthly',
                                          );
                                    }
                                  },
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
                                  targetValue:
                                      dashboardModel.maintenanceCostTargetValue,
                                  optimumTarget: dashboardModel
                                      .maintenanceCostOptimumTarget,
                                  targetCollection:
                                      dashboardModel.totalMaintenanceFeesToday,
                                  percentChange: HelperFunctions.percentChange(
                                    dashboardModel
                                        .totalMaintenanceFeesYesterday,
                                    dashboardModel.totalMaintenanceFeesToday,
                                  ),
                                  lastAmount: dashboardModel
                                      .totalMaintenanceFeesYesterday,
                                  onTabSelected: (value) {
                                    if (value == 0) {
                                      dashboardCubit
                                          .fetchMaintainanceCollectionAmount(
                                            'daily',
                                          );
                                    } else if (value == 1) {
                                      dashboardCubit
                                          .fetchMaintainanceCollectionAmount(
                                            'weekly',
                                          );
                                    } else if (value == 2) {
                                      dashboardCubit
                                          .fetchMaintainanceCollectionAmount(
                                            'monthly',
                                          );
                                    }
                                  },
                                ),
                              ),
                              Spacing.hMedium,
                              Expanded(
                                child: StatsOverviewCard(
                                  statsCardLabel: "Expenses Saved",
                                  targetValue: 0,
                                      // dashboardModel.expensesSavedTargetValue,
                                  optimumTarget: 0,
                                      // dashboardModel.expensesSavedOptimumTarget,
                                  targetCollection: 0,
                                  // dashboardModel
                                  //     .expensesSavedTargetCollection,
                                  percentChange: 0,
                                  onTabSelected: (value) {},
                                ),
                              ),
                            ],
                          ),
                          Spacing.vXXLarge,
                        ],
                      ),
                    ),
                  ),
                )
              : state is DashboardError
              ? Center(child: ResponsiveText('Error: ${state.message}'))
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
