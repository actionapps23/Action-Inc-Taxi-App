import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/routes/app_routes.dart';
import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit()
    : super(
        const SelectionState(
          taxiPlateNo: '',
          taxiNo: '',
          regNo: '',
          driverName: '',
        ),
      );

  void setTaxiNo(String value) => emit(state.copyWith(taxiNo: value));
  void setRegNo(String value) => emit(state.copyWith(regNo: value));
  void setDriverName(String value) => emit(state.copyWith(driverName: value));
  void setTaxiPlateNo(String value) => emit(state.copyWith(taxiPlateNo: value));

  void setAll({
    String? taxiPlateNo,
    String? regNo,
    String? driverName,
    String? taxiNo,
  }) => emit(
    state.copyWith(
      taxiPlateNo: taxiPlateNo ?? state.taxiPlateNo,
      regNo: regNo ?? state.regNo,
      driverName: driverName ?? state.driverName,
      taxiNo: taxiNo ?? state.taxiNo,
    ),
  );
  //

  final List<Map<String, dynamic>> featureCards = [
    {'title': "Rent a Car", 'icon': AppAssets.carDetailsIcon},
    {'title': "Car Details", 'icon': AppAssets.carDetailsIcon},
    {'title': "Maintenance", 'icon': AppAssets.maintenance},
    {'title': "Inventory", 'icon': AppAssets.inventory},
    {'title': "Taxi Inspection", 'icon': AppAssets.taxiInspection},
    {'title': "Open Procedure", 'icon': AppAssets.openProcedure},
    {'title': "Close Procedure", 'icon': AppAssets.closeProcedure},
    {'title': "Renewal & Status", 'icon': AppAssets.renewalStatus},
  ];

  //
  void proceed(int selectedIndex, BuildContext context, String? id) {
    if (id != null && id.isNotEmpty) {
      if (id.toLowerCase() == "future purchase") {
        {
          Navigator.pushNamed(context, AppRoutes.futurePurchase);
        }
      }
      if (id.toLowerCase() == "maintenance") {
        {
          Navigator.pushNamed(context, AppRoutes.maintainance);
        }
      } else if (id.toLowerCase() == "inventory") {
        {
          Navigator.pushNamed(context, AppRoutes.inventory);
        }
      } else if (id.toLowerCase() == "open procedure") {
        {
          Navigator.pushNamed(
            context,
            AppRoutes.procedure,
            arguments: const ProcedureRouteArgs(
              procedureType: AppConstants.openProcedure,
            ),
          );
        }
      } else if (id.toLowerCase() == "close procedure") {
        {
          Navigator.pushNamed(
            context,
            AppRoutes.procedure,
            arguments: const ProcedureRouteArgs(
              procedureType: AppConstants.closeProcedure,
            ),
          );
        }
      } else if (id.toLowerCase() == 'renewal & status') {
        Navigator.pushNamed(context, AppRoutes.renewalStatus);
      }
      return;
    }
    switch (selectedIndex) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.carDetail);
        break;
      case 1:
        Navigator.pushNamed(
          context,
          AppRoutes.carDetail,
          arguments: CarDetailRouteArgs(fetchDetails: true),
        );

        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.maintainance);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.inventory);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.vehicleViewSelection);
        break;
      case 5:
        Navigator.pushNamed(
          context,
          AppRoutes.procedure,
          arguments: const ProcedureRouteArgs(
            procedureType: AppConstants.openProcedure,
          ),
        );
        break;
      case 6:
        Navigator.pushNamed(
          context,
          AppRoutes.procedure,
          arguments: const ProcedureRouteArgs(
            procedureType: AppConstants.closeProcedure,
          ),
        );
      case 7:
        Navigator.pushNamed(context, AppRoutes.renewalStatus);
        break;
      case 8:
        Navigator.pushNamed(context, AppRoutes.purchase);
        break;
      case 9:
        Navigator.pushNamed(context, AppRoutes.franchiseTransfer);
        break;
      case 10:
        Navigator.pushNamed(context, AppRoutes.futurePurchase);
        break;
      default:
        break;
    }
  }

  void reset() => emit(
    const SelectionState(
      taxiNo: '',
      regNo: '',
      driverName: '',
      taxiPlateNo: '',
    ),
  );
}
