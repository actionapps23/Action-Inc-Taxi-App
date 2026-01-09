import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:action_inc_taxi_app/cubit/franchise_transfer/farnchise_transfer_state.dart';
import 'package:action_inc_taxi_app/services/franchise_transfer_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FranchiseTransferCubit extends Cubit<FranchiseTransferState> {
  FranchiseTransferCubit() : super(FranchiseTransferInitial());

  // function to get the data for newCarEquipment, ltfrbChecklist, ltoChecklist

  Future<void> getAllChecklists(String taxiPlateNumber) async {
    emit(FranchiseTransferLoading());
    try {
      final Map<String, List<FieldEntryModel>> data =
          await FranchiseTransferService.getAllChecklists(taxiPlateNumber);

      emit(
        AllDataLoaded(
          pnpData: data['pnpData'] ?? [],
          ltfrbData: data['ltfrbData'] ?? [],
          ltoData: data['ltoData'] ?? [],
        ),
      );
    } catch (e) {
      emit(FranchiseTransferError(message: e.toString()));
    }
  }

  Future<void> updateFranchiseTransferRecord(
    String taxiPlateNumber,
    FieldEntryModel updatedEntry,
    String collectionName,
  ) async {
    emit(FranchiseTransferLoading());
    try {
      await FranchiseTransferService.updateFranchiseTransferRecord(
        taxiPlateNumber,
        updatedEntry,
        collectionName,
      );
      await getAllChecklists(taxiPlateNumber);
    } catch (e) {
      emit(FranchiseTransferError(message: e.toString()));
    }
  }

  Future<void> saveAllChecklists(
    String taxiPlateNumber,
    List<FieldEntryModel> pnpData,
    List<FieldEntryModel> ltfrbData,
    List<FieldEntryModel> ltoData,
  ) async {
    emit(FranchiseTransferLoading());
    try {
      await Future.wait([
        FranchiseTransferService.saveFranchiseTransferRecord(
          taxiPlateNumber,
          pnpData,
          AppConstants.pnpRecordForFranchiseTransferCollection,
        ),
        FranchiseTransferService.saveFranchiseTransferRecord(
          taxiPlateNumber,
          ltfrbData,
          AppConstants.lftrbRecordForFranchiseTransferCollection,
        ),
        FranchiseTransferService.saveFranchiseTransferRecord(
          taxiPlateNumber,
          ltoData,
          AppConstants.ltoRecordForFranchiseTransferCollection,
        ),
      ]);
      emit(
        AllDataLoaded(pnpData: pnpData, ltfrbData: ltfrbData, ltoData: ltoData),
      );
    } catch (e) {
      emit(FranchiseTransferError(message: e.toString()));
    }
  }

  void reset() {
    emit(FranchiseTransferInitial());
  }
}
