import 'package:action_inc_taxi_app/core/models/dashboard_model.dart';

class DashboardState {
  final bool loading;
  final DashboardModel dashboardModel;
  DashboardState({
    this.loading = false,
    DashboardModel? dashboardModel,
  }) : dashboardModel = dashboardModel ?? const DashboardModel();

  DashboardState copyWith({
    bool? loading,
    DashboardModel? dashboardModel,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      dashboardModel: dashboardModel ?? this.dashboardModel,
    );
  }
}
