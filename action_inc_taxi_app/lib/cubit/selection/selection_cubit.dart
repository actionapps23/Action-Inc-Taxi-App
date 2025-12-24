import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/features/close_procedure/procedure_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_detail_main_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/inspection/vehicle_view_selection_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_and_status_screen.dart';
import 'package:action_inc_taxi_app/features/inventory/inventory_sceen.dart';
import 'package:action_inc_taxi_app/features/maintainence/maintainence_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit()
    : super(const SelectionState(taxiNo: '', regNo: '', driverName: ''));

  void setTaxiNo(String value) => emit(state.copyWith(taxiNo: value));
  void setRegNo(String value) => emit(state.copyWith(regNo: value));
  void setDriverName(String value) => emit(state.copyWith(driverName: value));

  void setAll({String? taxiNo, String? regNo, String? driverName}) => emit(
    state.copyWith(
      taxiNo: taxiNo ?? state.taxiNo,
      regNo: regNo ?? state.regNo,
      driverName: driverName ?? state.driverName,
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
      if (id.toLowerCase() == "maintenance") {
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MaintainenceScreen()),
          );
        }
      } else if (id.toLowerCase() == "inventory") {
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InventorySceen()),
          );
        }
      } else if (id.toLowerCase() == "open procedure") {
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProcedureScreen(procedureType: AppConstants.openProcedure),
            ),
          );
        }
      } else if (id.toLowerCase() == "close procedure") {
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProcedureScreen(procedureType: AppConstants.closeProcedure),
            ),
          );
        }
      } else if (id.toLowerCase() == 'renewal & status') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RenewalAndStatusScreen()),
        );
      }
      return;
    }
    switch (selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarDetailScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailScreen(fetchDetails: true),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MaintainenceScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InventorySceen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VehicleViewSelectionScreen(),
          ),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProcedureScreen(procedureType: AppConstants.closeProcedure),
          ),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProcedureScreen(procedureType: AppConstants.closeProcedure),
          ),
        );
        break;
      default:
        break;
    }
  }

  void reset() =>
      emit(const SelectionState(taxiNo: '', regNo: '', driverName: ''));
}
