import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:action_inc_taxi_app/cubit/purchase/purchase_state.dart';
import 'package:action_inc_taxi_app/services/purchase_service.dart';
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
      await PurchaseService.savePurchaseRecord(
        taxiPlateNumber,
        purchaseData,
        AppConstants.purchaseRecordsCollection,
      );
      final data = await PurchaseService.getPurchaseRecord(taxiPlateNumber);
      emit(PurchaseLoaded(purchaseData: data));
    } catch (e) {
      emit(PurchaseError(message: e.toString()));
    }
  }

  Future<void> updatePurchaseRecord(
    String taxiPlateNumber,
    FieldEntryModel updatedEntry,
    String collectionName, {
    final bool fromPurchaseScreen = true,
  }) async {
    emit(PurchaseLoading());
    try {
      await PurchaseService.updatePurchaseRecord(
        taxiPlateNumber,
        updatedEntry,
        collectionName,
      );
      if (fromPurchaseScreen) {
        getPurchaseRecord(taxiPlateNumber);
      } else {
        getAllChecklists(taxiPlateNumber);
      }
    } catch (e) {
      emit(PurchaseError(message: e.toString()));
    }
  }
  // function to get the data for newCarEquipment, ltfrbChecklist, ltoChecklist

  Future<void> getAllChecklists(String taxiPlateNumber) async {
    emit(PurchaseLoading());
    try {
      final Map<String, List<FieldEntryModel>> data =
          await PurchaseService.getAllChecklists(taxiPlateNumber);

      emit(
        AllDataLoaded(
          newCarEquipmentData: data['newCarEquipmentData'] ?? [],
          ltfrbData: data['ltfrbData'] ?? [],
          ltoData: data['ltoData'] ?? [],
        ),
      );
    } catch (e) {
      emit(PurchaseError(message: e.toString()));
    }
  }

  Future<void> saveAllChecklists(
    String taxiPlateNumber,
    List<FieldEntryModel> newCarEquipmentData,
    List<FieldEntryModel> ltfrbData,
    List<FieldEntryModel> ltoData,
  ) async {
    emit(PurchaseLoading());
    try {
      await Future.wait([
        PurchaseService.savePurchaseRecord(
          taxiPlateNumber,
          newCarEquipmentData,
          AppConstants.newCarEquipmentRecordCollection,
        ),
        PurchaseService.savePurchaseRecord(
          taxiPlateNumber,
          ltfrbData,
          AppConstants.lftrbRecordCollectionForNewCar,
        ),
        PurchaseService.savePurchaseRecord(
          taxiPlateNumber,
          ltoData,
          AppConstants.ltoRecordCollectionForNewCar,
        ),
      ]);
      emit(
        AllDataLoaded(
          newCarEquipmentData: newCarEquipmentData,
          ltfrbData: ltfrbData,
          ltoData: ltoData,
        ),
      );
    } catch (e) {
      emit(PurchaseError(message: e.toString()));
    }
  }

  // This function is to replace the temporary taxi plate number with the updated one
  Future<void> updateTaxiPlateNumber(
    String oldTaxiPlateNumber,
    String newTaxiPlateNumber,
  ) async {
    emit(PurchaseLoading());
    try {
      await PurchaseService.updateTaxiPlateNumber(
        oldTaxiPlateNumber,
        newTaxiPlateNumber,
        [
          AppConstants.purchaseRecordsCollection,
          AppConstants.newCarEquipmentRecordCollection,
          AppConstants.lftrbRecordCollectionForNewCar,
          AppConstants.ltoRecordCollectionForNewCar,
          AppConstants.lftrbRecordForFranchiseTransferCollection,
          AppConstants.pnpRecordForFranchiseTransferCollection,
          AppConstants.ltoRecordForFranchiseTransferCollection,
        ],
      );
      final purchaseData = await PurchaseService.getPurchaseRecord(
        newTaxiPlateNumber,
      );
      emit(PurchaseLoaded(purchaseData: purchaseData));
    } catch (e) {
      emit(PurchaseError(message: e.toString()));
    }
  }

  void reset() {
    emit(PurchaseInitial());
  }
}
