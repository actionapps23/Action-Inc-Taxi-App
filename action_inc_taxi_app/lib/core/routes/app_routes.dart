import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
import 'package:action_inc_taxi_app/features/auth/add_employee_screen/add_employee_screen.dart';
import 'package:action_inc_taxi_app/features/auth/login_screen.dart';
import 'package:action_inc_taxi_app/features/close_procedure/procedure_screen.dart';
import 'package:action_inc_taxi_app/features/dashboard/dashboard.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_detail_main_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/inspection/vehicle_view_selection_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_and_status_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_inspection_panel.dart';
import 'package:action_inc_taxi_app/features/franchise/franchise_transfer.dart';
import 'package:action_inc_taxi_app/features/future_purchase/future_purchase_screen.dart';
import 'package:action_inc_taxi_app/features/inventory/inventory_sceen.dart';
import 'package:action_inc_taxi_app/features/maintainence/maintainence_screen.dart';
import 'package:action_inc_taxi_app/features/purchase/purchase_screen.dart';
import 'package:action_inc_taxi_app/features/reporting/report_page.dart';
import 'package:action_inc_taxi_app/features/selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  const AppRoutes._();

  static const String login = '/login';
  static const String selection = '/selection';
  static const String dashboard = '/dashboard';
  static const String report = '/report';
  static const String addEmployee = '/add-employee';
  static const String maintainance = '/maintenance';
  static const String inventory = '/inventory';
  static const String vehicleViewSelection = '/vehicle-view-selection';
  static const String vehicleInspectionPanel = '/vehicle-inspection-panel';
  static const String renewalStatus = '/renewal-status';
  static const String carDetail = '/car-detail';
  static const String procedure = '/procedure';
  static const String purchase = '/purchase';
  static const String franchiseTransfer = '/franchise-transfer';
  static const String futurePurchase = '/future-purchase';

}

class AppRouter {
  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.selection: (_) => const SelectionScreen(),
        AppRoutes.dashboard: (_) => Dashboard(),
        AppRoutes.report: (_) => const ReportPage(),
        AppRoutes.addEmployee: (_) => AddEmployeeScreen(),
        AppRoutes.maintainance: (_) => MaintainenceScreen(),
        AppRoutes.inventory: (_) => InventorySceen(),
        AppRoutes.vehicleViewSelection: (_) =>
            const VehicleViewSelectionScreen(),
        AppRoutes.renewalStatus: (_) => RenewalAndStatusScreen(),
        AppRoutes.purchase: (_) => PurchaseScreen(),
        AppRoutes.franchiseTransfer: (_) => FranchiseTransfer(),
        AppRoutes.futurePurchase: (_) => FuturePurchaseScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {

        if (settings.name == AppRoutes.carDetail) {
          final args = settings.arguments as CarDetailRouteArgs?;
          return CarDetailScreen(
            fetchDetails: args?.fetchDetails ?? false,
          );
        }

        if (settings.name == AppRoutes.procedure) {
          final args = settings.arguments as ProcedureRouteArgs?;
          if (args == null) return const LoginScreen();
          return ProcedureScreen(
            procedureType: args.procedureType,
          );
        }

        if (settings.name == AppRoutes.vehicleInspectionPanel) {
          final args = settings.arguments as VehicleInspectionRouteArgs?;
          if (args == null) return const LoginScreen();
          return VehicleInspectionPanel(
            viewName: args.viewName,
            mapKey: args.mapKey,
          );
        }

        return const LoginScreen();
      },
    );
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const LoginScreen(),
    );
  }
}

class CarDetailRouteArgs {
  final bool fetchDetails;
  const CarDetailRouteArgs({this.fetchDetails = false});
}

class ProcedureRouteArgs {
  final String procedureType;
  const ProcedureRouteArgs({required this.procedureType});
}

class VehicleInspectionRouteArgs {
  final String viewName;
  final String mapKey;
  const VehicleInspectionRouteArgs({
    required this.viewName,
    required this.mapKey,
  });
}
