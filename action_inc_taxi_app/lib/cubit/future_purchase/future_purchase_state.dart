import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';

class FuturePurchaseState {}

class FuturePurchaseInitial extends FuturePurchaseState {}

class FuturePurchaseLoading extends FuturePurchaseState {}

class FuturePurchaseError extends FuturePurchaseState {
  final String message;

  FuturePurchaseError(this.message);
}

class FuturePurchaseEntryAdding extends FuturePurchaseState {}

class FuturePurchaseEntryAdded extends FuturePurchaseState {}

class FuturePurchaseEntryAddError extends FuturePurchaseState {
  final String message;

  FuturePurchaseEntryAddError(this.message);
}

class FuturePurchaseEntryUpdating extends FuturePurchaseState {}

class FuturePurchaseEntryUpdated extends FuturePurchaseState {}

class FuturePurchaseEntryUpdateError extends FuturePurchaseState {
  final String message;

  FuturePurchaseEntryUpdateError(this.message);
}

class FuturePurchaseEntryDeleting extends FuturePurchaseState {}

class FuturePurchaseEntryDeleted extends FuturePurchaseState {}

class FuturePurchaseEntryDeleteError extends FuturePurchaseState {
  final String message;

  FuturePurchaseEntryDeleteError(this.message);
}

class FuturePurchaseEntriesLoaded extends FuturePurchaseState {
  final List<FieldEntryModel> entries;

  FuturePurchaseEntriesLoaded(this.entries);
}
