import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:action_inc_taxi_app/cubit/purchase/purchase_state.dart';
import 'package:action_inc_taxi_app/services/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit() : super(PurchaseInitial());

  Future<void> getPurchaseRecord(String taxiPlateNumber) async {
    emit(PurchaseLoading());
    try {
      final purchaseData = await PurchaseService.getPurchaseRecord(
        taxiPlateNumber,
      );
      emit(PurchaseLoaded(purchaseData: purchaseData));
    } catch (e) {
      emit(PurchaseError(message: e.toString()));
    }
  }

  Future<void> savePurchaseRecord(
    String taxiPlateNumber,
    List<FieldEntryModel> purchaseData,
  ) async {
    emit(PurchaseLoading());
    try {
      await PurchaseService.savePurchaseRecord(taxiPlateNumber, purchaseData);
      final data = await PurchaseService.getPurchaseRecord(taxiPlateNumber);
      emit(PurchaseLoaded(purchaseData: data));
    } catch (e) {
      debugPrint("Error saving purchase record: $e");
      emit(PurchaseError(message: e.toString()));
    }
  }
}
