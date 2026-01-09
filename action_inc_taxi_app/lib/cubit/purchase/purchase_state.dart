import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';

class PurchaseState {}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseLoaded extends PurchaseState {
  final List<FieldEntryModel> purchaseData;

  PurchaseLoaded({required this.purchaseData});
}

class PurchaseError extends PurchaseState {
  final String message;

  PurchaseError({required this.message});
}

// State for newCarEquipment, LTFRB, LTO
// This state indicates that all data has been successfully loaded
class AllDataLoaded extends PurchaseState {
  final List<FieldEntryModel> newCarEquipmentData;
  final List<FieldEntryModel> ltfrbData;
  final List<FieldEntryModel> ltoData;

  AllDataLoaded({
    required this.newCarEquipmentData,
    required this.ltfrbData,
    required this.ltoData,
  });
}
