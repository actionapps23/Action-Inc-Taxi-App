import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState());
  final DbService dbService = DbService();
  Future<void> fetchTodayBankedAmounts() async {
    emit(state.copyWith(loading: true));
    final amounts = await dbService.getTodaysAmount();
    final dashboardModel = state.dashboardModel.copyWith(
      totalAmountPaid: amounts['totalAmount'] ?? 0,
      totalCashAmount: amounts['totalCash'] ?? 0,
      totalGCashAmount: amounts['totalGCash'] ?? 0,
    );
    emit(DashboardState(
      dashboardModel: dashboardModel,
      loading: false,
    ));
  }
}
