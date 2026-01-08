import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FranchiseTransferService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveFranchiseTransferRecord(
    String taxiPlateNumber,
    List<FieldEntryModel> franchiseTransferData,
    final String collectionName,
  ) async {
    try {
      await _firestore.collection(collectionName).doc(taxiPlateNumber).set({
        'last_updated': FieldValue.serverTimestamp(),
      });

      for (var i in franchiseTransferData) {
        await _firestore
            .collection(collectionName)
            .doc(taxiPlateNumber)
            .collection(taxiPlateNumber)
            .doc(i.id)
            .set(i.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<FieldEntryModel>> getFranchiseTransferRecord(
    String taxiPlateNumber,
  ) async {
    try {
      final List<FieldEntryModel> franchiseTransferData = [];
      QuerySnapshot querySnapshot = await _firestore
          .collection(AppConstants.purchaseRecordsCollection)
          .doc(taxiPlateNumber)
          .collection(taxiPlateNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          franchiseTransferData.add(FieldEntryModel.fromJson(data));
        }
        return franchiseTransferData;
      }
      return franchiseTransferData;
    } catch (e) {
      rethrow;
    }
  }
  static Future<void> updateFranchiseTransferRecord(
    String taxiPlateNumber,
    FieldEntryModel updatedEntry,
    String collectionName
  ){

    try {
      return _firestore
          .collection(collectionName)
          .doc(taxiPlateNumber)
          .collection(taxiPlateNumber)
          .doc(updatedEntry.id)
          .set(updatedEntry.toJson());
    } catch (e) {
      rethrow;
    }
  }
  static Future<Map<String, List<FieldEntryModel>>> getAllChecklists(
    String taxiPlateNumber,
  ) async {
    final List<FieldEntryModel> pnpCheckListCollectionForFranchiseTransfer = [];
    final List<FieldEntryModel> lftrbCheckListCollectionForFranchiseTransfer = [];
    final List<FieldEntryModel> ltoCheckListCollectionForFranchiseTransfer = [];

    QuerySnapshot pnpRecordForFranchiseTransferSnapshot = await _firestore
        .collection(AppConstants.pnpRecordForFranchiseTransferCollection)
        .doc(taxiPlateNumber)
        .collection(taxiPlateNumber)
        .get();

    if (pnpRecordForFranchiseTransferSnapshot.docs.isNotEmpty) {
      for (var doc in pnpRecordForFranchiseTransferSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        pnpCheckListCollectionForFranchiseTransfer.add(FieldEntryModel.fromJson(data));
      }
    }
    QuerySnapshot lftrbSnapshot = await _firestore
        .collection(AppConstants.lftrbRecordForFranchiseTransferCollection)
        .doc(taxiPlateNumber)
        .collection(taxiPlateNumber)
        .get();

    if (lftrbSnapshot.docs.isNotEmpty) {
      for (var doc in lftrbSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        lftrbCheckListCollectionForFranchiseTransfer.add(FieldEntryModel.fromJson(data));
      }
    }

    QuerySnapshot ltoSnapshot = await _firestore
        .collection(AppConstants.ltoRecordForFranchiseTransferCollection)
        .doc(taxiPlateNumber)
        .collection(taxiPlateNumber)
        .get();

    if (ltoSnapshot.docs.isNotEmpty) {
      for (var doc in ltoSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        ltoCheckListCollectionForFranchiseTransfer.add(FieldEntryModel.fromJson(data));
      }
    }

    final purchaseData = {
      'pnpData': pnpCheckListCollectionForFranchiseTransfer,
      'ltfrbData': lftrbCheckListCollectionForFranchiseTransfer,
      'ltoData': ltoCheckListCollectionForFranchiseTransfer,
    };
    return purchaseData;
  }

}
