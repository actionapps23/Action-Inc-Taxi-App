import 'package:action_inc_taxi_app/core/models/section_model.dart';

class VehicleInspectionPanelState {
  final List<CategoryModel>? inspectionChecklistFromDB;
  final Map<String, bool> checkedFields;
  final Map<String, bool> checkedFieldsFromDB;

  const VehicleInspectionPanelState({
    this.inspectionChecklistFromDB,
    this.checkedFields = const {},
    this.checkedFieldsFromDB = const {},
  });

  VehicleInspectionPanelState copyWith({
    List<CategoryModel>? inspectionChecklistFromDB,
    Map<String, bool>? checkedFields,
    Map<String, bool>? checkedFieldsFromDB,
  }) {
    return VehicleInspectionPanelState(
      inspectionChecklistFromDB:
          inspectionChecklistFromDB ?? this.inspectionChecklistFromDB,
      checkedFields: checkedFields ?? this.checkedFields,
      checkedFieldsFromDB: checkedFieldsFromDB ?? this.checkedFieldsFromDB,
    );
  }
}

class VehicleInspectionChecklistLoading extends VehicleInspectionPanelState {}

class VehicleInspectionChecklistLoaded extends VehicleInspectionPanelState {
  VehicleInspectionChecklistLoaded(
    List<CategoryModel> inspectionChecklistFromDB, {
    Map<String, bool>? checkedFields,
    Map<String, bool>? checkedFieldsFromDB,
  }) : super(
         inspectionChecklistFromDB: inspectionChecklistFromDB,
         checkedFields: checkedFields ?? {},
         checkedFieldsFromDB: checkedFieldsFromDB ?? {},
       );

  @override
  VehicleInspectionChecklistLoaded copyWith({
    List<CategoryModel>? inspectionChecklistFromDB,
    Map<String, bool>? checkedFields,
    Map<String, bool>? checkedFieldsFromDB,
  }) {
    return VehicleInspectionChecklistLoaded(
      inspectionChecklistFromDB ?? this.inspectionChecklistFromDB!,
      checkedFields: checkedFields ?? this.checkedFields,
      checkedFieldsFromDB: checkedFieldsFromDB ?? this.checkedFieldsFromDB,
    );
  }
}

class VehicleIsnpectionChecklistError extends VehicleInspectionPanelState {
  final String errorMessage;

  VehicleIsnpectionChecklistError(this.errorMessage);
}

class VehicleInspectionDataLoading extends VehicleInspectionPanelState {}

class VehicleInspectionDataLoaded extends VehicleInspectionPanelState {
  final String fieldKey;

  VehicleInspectionDataLoaded({
    required this.fieldKey,
    required super.checkedFieldsFromDB,
    required super.inspectionChecklistFromDB,
    required super.checkedFields,
  });

  @override
  VehicleInspectionDataLoaded copyWith({
    List<CategoryModel>? inspectionChecklistFromDB,
    Map<String, bool>? checkedFields,
    Map<String, bool>? checkedFieldsFromDB,
    String? fieldKey,
  }) {
    return VehicleInspectionDataLoaded(
      fieldKey: fieldKey ?? this.fieldKey,
      inspectionChecklistFromDB:
          inspectionChecklistFromDB ?? this.inspectionChecklistFromDB!,
      checkedFields: checkedFields ?? this.checkedFields,
      checkedFieldsFromDB: checkedFieldsFromDB ?? this.checkedFieldsFromDB,
    );
  }
}

class VehicleInspectionDataError extends VehicleInspectionPanelState {
  final String errorMessage;

  VehicleInspectionDataError(this.errorMessage);
}
