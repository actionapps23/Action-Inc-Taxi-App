import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());
  final DbService dbService = DbService();

  void updateTodayBankedAmount(int newAmount) {
    final updatedDashboard = state.dashboardModel.copyWith(
      totalAmountPaidToday: newAmount,
    );
    emit(DashboardLoaded(updatedDashboard));
  }

  Future<void> fetchTodayBankedAmounts() async {
    emit(DashboardLoading(state.dashboardModel));
    try {
      final amounts = await dbService.getLastTwoDaysIncome();
      final dashboardModel = state.dashboardModel.copyWith(
        totalAmountPaidToday: amounts['totalAmountToday'] ?? 0,
        totalCashAmountToday: amounts['totalCashToday'] ?? 0,
        totalGCashAmountToday: amounts['totalGCashToday'] ?? 0,
        totalBankedAmountToday: amounts['totalBankedToday'] ?? 0,

        totalAmountYesterday: amounts['totalAmountYesterday'] ?? 0,
        totalCashAmountYesterday: amounts['totalCashYesterday'] ?? 0,
        totalGCashAmountYesterday: amounts['totalGCashYesterday'] ?? 0,
        totalBankedAmountYesterday: amounts['totalBankedYesterday'] ?? 0,
      );
      emit(DashboardLoaded(dashboardModel));
    } catch (e) {
      emit(DashboardError(state.dashboardModel, e.toString()));
    }
  }

  Future<void> fetchFleetAmounts(
    String periodType, {
    bool isForPieChart = false,
  }) async {
    final amounts = await dbService.getFleetAmountsByPeriod(
      periodType: periodType,
    );
    if (isForPieChart) {
      final updatedDashboard = state.dashboardModel.copyWith(
        fleet1Amt: amounts['fleet1Amt'] ?? 0,
        fleet2Amt: amounts['fleet2Amt'] ?? 0,
        fleet3Amt: amounts['fleet3Amt'] ?? 0,
        fleet4Amt: amounts['fleet4Amt'] ?? 0,
        totalFleetAmtForChart: amounts['totalAmt'] ?? 0,
      );
      emit(DashboardLoaded(updatedDashboard));
    } else {
      final updatedDashboard = state.dashboardModel.copyWith(
        totalFleetAmtForStatsCard: amounts['totalAmt'] ?? 0,
        fleetIncomePreviousPeriod: amounts['fleetIncomePreviousPeriod'] ?? 0,
      );
      emit(DashboardLoaded(updatedDashboard));
    }
  }

  Future<void> fetchMaintainanceCollectionAmount(String periodType) async {
    final amounts = await dbService.getMaintainanceCollectionByPeriod(
      periodType,
    );
    final updatedDashboard = state.dashboardModel.copyWith(
      totalMaintenanceFeesToday: amounts['totalMaintenanceFeesToday'] ?? 0,
      totalMaintenanceFeesYesterday:
          amounts['totalMaintenanceFeesYesterday'] ?? 0,
    );
    emit(DashboardLoaded(updatedDashboard));
  }

  Future<void> fetchcarWashCollectionAmount(String periodType) async {
    final amounts = await dbService.getCarWashCollectionByPeriod(periodType);
    final updatedDashboard = state.dashboardModel.copyWith(
      totalCarWashFeesToday: amounts['totalCarWashFeesToday'] ?? 0,
      totalCarWashFeesYesterday: amounts['totalCarWashFeesYesterday'] ?? 0,
    );
    emit(DashboardLoaded(updatedDashboard));
  }

  Future<void> getFleetIncomeForYear() async {
    try {
      emit(DashboardLoading(state.dashboardModel));

      var amounts = await dbService.getFleetIncomeForYear();
      final monthlyIncomes = <int>[];
      final currentMonth = DateTime.now().month;

      for (var i = 0; i < currentMonth; i++) {
        final month = AppConstants.monthNames[i];
        final monthData = amounts[month];
        if (monthData != null && monthData['totalAmount'] != null) {
          monthlyIncomes.add(monthData['totalAmount'] as int);
        } else {
          monthlyIncomes.add(0);
        }
      }
      emit(
        DashboardLoaded(
          state.dashboardModel.copyWith(monthlyFleetIncomes: monthlyIncomes),
        ),
      );
    } catch (e) {
      emit(DashboardError(state.dashboardModel, e.toString()));
    }
  }
}
