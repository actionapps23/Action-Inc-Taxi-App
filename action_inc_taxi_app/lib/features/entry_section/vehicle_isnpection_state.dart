class VehicleInspectionPanelState {
  final Map<String, bool> checkedFields;

  const VehicleInspectionPanelState({this.checkedFields = const {}});

  VehicleInspectionPanelState copyWith({Map<String, bool>? checkedFields}) {
    return VehicleInspectionPanelState(
      checkedFields: checkedFields ?? this.checkedFields,
    );
  }
}
