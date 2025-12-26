import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:action_inc_taxi_app/cubit/field/field_state.dart';
import 'package:action_inc_taxi_app/services/field_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldCubit extends Cubit<FieldState> {
  final String collectionName;
  final String documentId;
  FieldCubit({required this.collectionName, required this.documentId})
    : super(FieldInitial());
  late final FieldService fieldService = FieldService(
    collectionName: collectionName,
    documentId: documentId,
  );

  Future<void> addFieldEntry(FieldEntryModel field) async {
    emit(FieldEntryAdding());
    try {
      await fieldService.addFieldEntry(field);
      emit(FieldEntryAdded());
      await Future.delayed(Duration(seconds: 3));
      await loadFieldEntries();
    } catch (e) {
      emit(FieldEntryAddError(e.toString()));
    }
  }

  Future<void> updateFieldEntry(FieldEntryModel field) async {
    emit(FieldEntryUpdating());
    try {
      await fieldService.updateFieldEntry(field);
      emit(FieldEntryUpdated());
      await Future.delayed(Duration(seconds: 3));
      await loadFieldEntries();
    } catch (e) {
      emit(FieldEntryUpdateError(e.toString()));
    }
  }

  Future<void> deleteFieldEntry(String fieldId) async {
    emit(FieldEntryDeleting());
    try {
      await fieldService.deleteFieldEntry(fieldId);
      emit(FieldEntryDeleted());
      await Future.delayed(Duration(seconds: 3));
      await loadFieldEntries();
    } catch (e) {
      emit(FieldEntryDeleteError(e.toString()));
    }
  }

  Future<void> loadFieldEntries() async {
    emit(FieldLoading());
    try {
      final entries = await fieldService.getFieldEntries();
      emit(FieldEntriesLoaded(entries));
    } catch (e) {
      emit(FieldError(e.toString()));
    }
  }
}
