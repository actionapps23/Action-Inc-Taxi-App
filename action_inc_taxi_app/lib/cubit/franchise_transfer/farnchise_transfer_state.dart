import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';

class FranchiseTransferState {}

class FranchiseTransferInitial extends FranchiseTransferState {}

class FranchiseTransferLoading extends FranchiseTransferState {}

class FranchiseTransferLoaded extends FranchiseTransferState {
  final List<FieldEntryModel> purchaseData;

  FranchiseTransferLoaded({required this.purchaseData});
}

class FranchiseTransferError extends FranchiseTransferState {
  final String message;

  FranchiseTransferError({required this.message});
}

// State for pnpData, LTFRB, LTO
// This state indicates that all data has been successfully loaded
class AllDataLoaded extends FranchiseTransferState {
  final List<FieldEntryModel> pnpData;
  final List<FieldEntryModel> ltfrbData;
  final List<FieldEntryModel> ltoData;

  AllDataLoaded({
    required this.pnpData,
    required this.ltfrbData,
    required this.ltoData,
  });
}
