import 'package:action_inc_taxi_app/features/entry_section/vehicle_isnpection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleInspectionPanelCubit extends Cubit<VehicleInspectionPanelState> {
  VehicleInspectionPanelCubit()
      : super(const VehicleInspectionPanelState());

  void toggleField(String fieldKey) {
    final updatedMap = Map<String, bool>.from(state.checkedFields);
    updatedMap[fieldKey] = !(updatedMap[fieldKey] ?? false);
    emit(state.copyWith(checkedFields: updatedMap));
  }

  bool isChecked(String fieldKey) {
    return state.checkedFields[fieldKey] ?? false;
  }
  void resetAll() {
    emit(const VehicleInspectionPanelState());
  }
}
