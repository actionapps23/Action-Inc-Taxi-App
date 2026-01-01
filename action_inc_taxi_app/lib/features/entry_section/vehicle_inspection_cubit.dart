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

  // Future<void> submitInspectionData(
  //   String plateNumber,
  //   String view,
  //   List<CategoryModel> categories,
  // ) async {
  //   try {
  //     emit(VehicleInspectionPanelLoadingState());
  //     await InspectionService.submitInspectionData(
  //       plateNumber,
  //       view,
  //       categories,
  //     );
  //     await fetchSubmittedInspectionData(plateNumber, view);
  //   } catch (e) {
  //     emit(VehicleInspectionPanelErrorState(e.toString()));
  //   }
  // }

  // Future<void> fetchSubmittedInspectionData(
  //   String plateNumber,
  //   String view,
  // ) async {
  //   try {
  //     emit(VehicleInspectionPanelLoadingState());
  //     final data = await InspectionService.fetchSubmittedInspectionData(
  //       plateNumber,
  //       view,
  //     );
  //     final Map<String, bool> checkedFieldsFromDB = {};
  //     for (var category in data) {
  //       for (var field in category.fields) {
  //         checkedFieldsFromDB[field.fieldKey] = field.isChecked;
  //       }
  //     }
  //     emit(
  //       VehicleInspectionPanelLoadedState(
  //         data,
  //         checkedFieldsFromDB,
  //         checkedFieldsFromDB,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(VehicleInspectionPanelErrorState(e.toString()));
  //   }
  // }

  // Future<void> updateInspectionChecklist({
  //   required String plateNumber,
  //   required String view,
  //   required CategoryModel category,
  // }) async {
  // try{
  //     await InspectionService.updateInspectionChecklist(
  //     plateNumber: plateNumber,
  //     view: view,
  //     category: category,
  //   );
  //   await fetchSubmittedInspectionData(plateNumber, view);
  // }
  // catch(e){
  //   emit(VehicleInspectionPanelErrorState(e.toString()));
  // }
  // }

  Future<void> fetchInspectionChecklist(String view) async {
    try {
      emit(VehicleInspectionChecklistLoading());
      final data = await InspectionService.fetchInspectionChecklist(view);
      emit(VehicleInspectionChecklistLoaded(data));
    } catch (e) {
      emit(VehicleIsnpectionChecklistError(e.toString()));
    }
  }

  Future<void> updateInspectionChecklist({
    required String view,
    required CategoryModel category,
      }) async {
    try {
      await InspectionService.updateCheckList(view, category);

      await fetchInspectionChecklist(view);
      await fetchSubmittedInspectionData(
        '66',
        view,
      );
    } catch (e) {
      emit(VehicleInspectionDataError(e.toString()));
    }
  }

  Future<void> addItemToChecklist(
    String view,
    CategoryModel inspectionChecklist,
  ) {
    try {
      emit(VehicleInspectionChecklistLoading());
      InspectionService.addItemToChecklist(
        view: view,
        category: inspectionChecklist,
      );
    } catch (e) {
      emit(VehicleIsnpectionChecklistError(e.toString()));
    }
    return Future.value();
  }

  Future<void> fetchSubmittedInspectionData(
    String plateNumber,
    String view,
  ) async {
    try {
      final state = this.state;
      emit(VehicleInspectionDataLoading());
      final data = await InspectionService.fetchSubmittedInspectionData(
        plateNumber,
        view,
      );
      emit(
        VehicleInspectionDataLoaded(
          inspectionChecklistFromDB: state.inspectionChecklistFromDB,
          checkedFields: data,
          checkedFieldsFromDB: data,
          fieldKey: view,
        ),
      );
    } catch (e) {
      emit(VehicleInspectionDataError(e.toString()));
    }
  }

  Future<void> submitInspectionData(String plateNumber, String view) async {
    try {
      final state = this.state;
      emit(VehicleInspectionDataLoading());
      await InspectionService.submitInspectionData(
        state.checkedFields,
        plateNumber,
        view,
      );
      emit(VehicleInspectionChecklistLoaded(state.inspectionChecklistFromDB ?? []));
      await fetchSubmittedInspectionData(plateNumber, view);
    } catch (e) {
      emit(VehicleInspectionDataError(e.toString()));
    }
  }

  Future<void> updateInspectionData({
    required String plateNumber,
    required String view,
    required Map<String, bool> updatedFields,
  }) async {
    try {
      await InspectionService.updateInspectionData(
        plateNumber,
        view,
        updatedFields,
      );
      await fetchSubmittedInspectionData(plateNumber, view);
    } catch (e) {
      emit(VehicleInspectionDataError(e.toString()));
    }
  }

  void resetAll() {
    emit(VehicleInspectionPanelState());
  }
}
