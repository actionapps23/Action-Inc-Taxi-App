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