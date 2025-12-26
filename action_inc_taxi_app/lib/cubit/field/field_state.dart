import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';

class FieldState {}

class FieldInitial extends FieldState {}

class FieldLoading extends FieldState {}

class FieldError extends FieldState {
  final String message;

  FieldError(this.message);
}

class FieldEntryAdding extends FieldState {}

class FieldEntryAdded extends FieldState {}

class FieldEntryAddError extends FieldState {
  final String message;

  FieldEntryAddError(this.message);
}

class FieldEntryUpdating extends FieldState {}

class FieldEntryUpdated extends FieldState {}

class FieldEntryUpdateError extends FieldState {
  final String message;

  FieldEntryUpdateError(this.message);
}

class FieldEntryDeleting extends FieldState {}

class FieldEntryDeleted extends FieldState {}

class FieldEntryDeleteError extends FieldState {
  final String message;

  FieldEntryDeleteError(this.message);
}

class FieldEntriesLoaded extends FieldState {
  final List<FieldEntryModel> entries;

  FieldEntriesLoaded(this.entries);
}
