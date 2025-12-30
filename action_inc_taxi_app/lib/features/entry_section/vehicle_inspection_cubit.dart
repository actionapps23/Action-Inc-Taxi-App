import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_isnpection_state.dart';
import 'package:action_inc_taxi_app/services/inspection_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleInspectionPanelCubit extends Cubit<VehicleInspectionPanelState> {
  VehicleInspectionPanelCubit() : super(VehicleInspectionPanelState());

  void toggleField(String fieldKey) {
    final updatedMap = Map<String, bool>.from(state.checkedFields);
    updatedMap[fieldKey] = !(updatedMap[fieldKey] ?? false);
    emit(state.copyWith(checkedFields: updatedMap));
  }

  bool isChecked(String fieldKey) {
    return state.checkedFields[fieldKey] ?? false;
  }

  Future<void> submitInspectionData(
    String taxiID,
    String view,
    List<CategoryModel> categories,
  ) async {
    try {
      emit(VehicleInspectionPanelLoadingState());
      await InspectionService.submitInspectionData(taxiID, view, categories);
      await fetchSubmittedInspectionData(taxiID, view);
    } catch (e) {
      emit(VehicleInspectionPanelErrorState(e.toString()));
    }
  }

  Future<void> fetchSubmittedInspectionData(String taxiID, String view) async {
    try {
      emit(VehicleInspectionPanelLoadingState());
      final data = await InspectionService.fetchSubmittedInspectionData(
        taxiID,
        view,
      );
      final Map<String, bool> checkedFieldsFromDB = {};
      for (var category in data) {
        for (var field in category.fields) {
          checkedFieldsFromDB[field.fieldKey] = field.isChecked;
        }
      }
      emit(VehicleInspectionPanelLoadedState(data).copyWith(checkedFieldsFromDB: checkedFieldsFromDB, checkedFields: checkedFieldsFromDB));
    } catch (e) {
      emit(VehicleInspectionPanelErrorState(e.toString()));
    }
  }

  void resetAll() {
    emit(VehicleInspectionPanelState());
  }
}
