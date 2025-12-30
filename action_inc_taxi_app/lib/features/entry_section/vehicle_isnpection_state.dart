import 'package:action_inc_taxi_app/core/models/section_model.dart';

class VehicleInspectionPanelState {
  final List<CategoryModel>? categories;
  final Map<String, bool> checkedFields;
  final Map<String, bool> checkedFieldsFromDB;

  const VehicleInspectionPanelState({this.categories, this.checkedFields = const {}, this.checkedFieldsFromDB = const {}});

  VehicleInspectionPanelState copyWith({List<CategoryModel>? categories, Map<String, bool>? checkedFields, Map<String, bool>? checkedFieldsFromDB}) {
    return VehicleInspectionPanelState(
      categories: categories ?? this.categories,
      checkedFields: checkedFields ?? this.checkedFields,
      checkedFieldsFromDB: checkedFieldsFromDB ?? this.checkedFieldsFromDB,
    );
  }
}


class VehicleInspectionPanelLoadingState extends VehicleInspectionPanelState {}

class VehicleInspectionPanelLoadedState extends VehicleInspectionPanelState {
  VehicleInspectionPanelLoadedState(List<CategoryModel>? categories)
      : super(categories: categories);
}

class VehicleInspectionPanelErrorState extends VehicleInspectionPanelState {
  final String errorMessage;

  VehicleInspectionPanelErrorState(this.errorMessage);
}

