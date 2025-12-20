import 'package:action_inc_taxi_app/core/models/dashboard_model.dart';

abstract class DashboardState {
  final DashboardModel dashboardModel;
  const DashboardState(this.dashboardModel);
}

class DashboardInitial extends DashboardState {
  DashboardInitial() : super(const DashboardModel());
}

class DashboardLoading extends DashboardState {
  DashboardLoading(super.dashboardModel);
}

class DashboardLoaded extends DashboardState {
  DashboardLoaded(super.dashboardModel);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(super.dashboardModel, this.message);
}
