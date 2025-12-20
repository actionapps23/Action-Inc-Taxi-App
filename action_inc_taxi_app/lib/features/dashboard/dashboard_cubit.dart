import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());
  final DbService dbService = DbService();

  Future<void> fetchTodayBankedAmounts() async {
    emit(DashboardLoading(state.dashboardModel));
    try {
      final amounts = await dbService.getTodaysAmount();
      final dashboardModel = state.dashboardModel.copyWith(
        totalAmountPaid: amounts['totalAmount'] ?? 0,
        totalCashAmount: amounts['totalCash'] ?? 0,
        totalGCashAmount: amounts['totalGCash'] ?? 0,
      );
      emit(DashboardLoaded(dashboardModel));
    } catch (e) {
      emit(DashboardError(state.dashboardModel, e.toString()));
    }
  }

  Future<void> fetchFleetAmounts(String periodType) async {
      final amounts = await dbService.getFleetAmountsByPeriod(periodType: periodType);
      final updatedDashboard = state.dashboardModel.copyWith(
        fleet1Amt: amounts['fleet1Amt'] ?? 0,
        fleet2Amt: amounts['fleet2Amt'] ?? 0,
        fleet3Amt: amounts['fleet3Amt'] ?? 0,
        fleet4Amt: amounts['fleet4Amt'] ?? 0,
        totalFleetAmt: amounts['totalAmt'] ?? 0,
      );
      emit(DashboardLoaded(updatedDashboard));
    
  }
}


