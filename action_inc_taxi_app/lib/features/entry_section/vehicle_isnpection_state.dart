import 'package:action_inc_taxi_app/core/models/section_model.dart';

class VehicleInspectionPanelState {
  final List<CategoryModel>? categories;
  final Map<String, bool> checkedFields;

  const VehicleInspectionPanelState({this.categories, this.checkedFields = const {}});

  VehicleInspectionPanelState copyWith({List<CategoryModel>? categories, Map<String, bool>? checkedFields}) {
    return VehicleInspectionPanelState(
      categories: categories ?? this.categories,
      checkedFields: checkedFields ?? this.checkedFields,
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

