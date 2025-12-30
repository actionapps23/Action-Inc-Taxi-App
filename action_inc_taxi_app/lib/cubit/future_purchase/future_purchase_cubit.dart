import 'package:action_inc_taxi_app/core/models/future_purchase_model.dart';
import 'package:action_inc_taxi_app/cubit/future_purchase/future_purchase_state.dart';
import 'package:action_inc_taxi_app/services/future_purchase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuturePurchaseCubit extends Cubit<FuturePurchaseState> {
  FuturePurchaseCubit() : super(FuturePurchaseInitial());

  final FuturePurchaseService fieldService = FuturePurchaseService();

  Future<void> addFieldEntry(FuturePurchaseModel field) async {
    emit(FuturePurchaseEntryAdding());
    try {
      await fieldService.addFieldEntry(field);
      emit(FuturePurchaseEntryAdded());
      await Future.delayed(Duration(seconds: 3));
      await loadFieldEntries();
    } catch (e) {
      emit(FuturePurchaseEntryAddError(e.toString()));
    }
  }

  Future<void> updateFieldEntry(FuturePurchaseModel field) async {
    emit(FuturePurchaseEntryUpdating());
    try {
      await fieldService.updateFieldEntry(field);
      emit(FuturePurchaseEntryUpdated());
      await Future.delayed(Duration(seconds: 3));
      await loadFieldEntries();
    } catch (e) {
      emit(FuturePurchaseEntryUpdateError(e.toString()));
    }
  }

  Future<void> deleteFieldEntry(String fieldId) async {
    emit(FuturePurchaseEntryDeleting());
    try {
      await fieldService.deleteFieldEntry(fieldId);
      emit(FuturePurchaseEntryDeleted());
      await Future.delayed(Duration(seconds: 3));
      await loadFieldEntries();
    } catch (e) {
      emit(FuturePurchaseEntryDeleteError(e.toString()));
    }
  }

  Future<void> loadFieldEntries() async {
    emit(FuturePurchaseLoading());
    try {
      final entries = await fieldService.getFieldEntries();
      emit(FuturePurchaseEntriesLoaded(entries));
    } catch (e) {
      emit(FuturePurchaseError(e.toString()));
    }
  }
}
