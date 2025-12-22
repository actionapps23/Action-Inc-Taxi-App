import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());
  final DbService dbService = DbService();

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

  Future<void> fetchFleetAmounts(String periodType) async {
    final amounts = await dbService.getFleetAmountsByPeriod(
      periodType: periodType,
    );
    final updatedDashboard = state.dashboardModel.copyWith(
      fleet1Amt: amounts['fleet1Amt'] ?? 0,
      fleet2Amt: amounts['fleet2Amt'] ?? 0,
      fleet3Amt: amounts['fleet3Amt'] ?? 0,
      fleet4Amt: amounts['fleet4Amt'] ?? 0,
      totalFleetAmt: amounts['totalAmt'] ?? 0,
      fleetIncomePreviousPeriod : amounts['fleetIncomePreviousPeriod'] ?? 0,
    );
    emit(DashboardLoaded(updatedDashboard));
  }

  Future<void> fetchMaintainanceCollectionAmount(String periodType) async {
    emit(DashboardLoading(state.dashboardModel));
    final amounts = await dbService.getMaintainanceCollectionByPeriod(
      periodType
    );
    final updatedDashboard = state.dashboardModel.copyWith(
      totalMaintenanceFeesToday:
          amounts['totalMaintenanceFeesToday'] ?? 0,
      totalMaintenanceFeesYesterday:
          amounts['totalMaintenanceFeesYesterday'] ?? 0,
    );
    emit(DashboardLoaded(updatedDashboard));
  }

  Future<void> fetchcarWashCollectionAmount(String periodType) async {
    emit(DashboardLoading(state.dashboardModel));
    final amounts = await dbService.getCarWashCollectionByPeriod(
      periodType
    );
    final updatedDashboard = state.dashboardModel.copyWith(
      totalCarWashFeesToday:
          amounts['totalCarWashFeesToday'] ?? 0,
      totalCarWashFeesYesterday:
          amounts['totalCarWashFeesYesterday'] ?? 0,
    );
    emit(DashboardLoaded(updatedDashboard));
  }
}
