import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> savePurchaseRecord(
    String taxiPlateNumber,
    List<FieldEntryModel> purchaseData,
    final String collectionName,
  ) async {
    try {
      await _firestore.collection(collectionName).doc(taxiPlateNumber).set({
        'last_updated': FieldValue.serverTimestamp(),
      });

      for (var i in purchaseData) {
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

  static Future<void> updatePurchaseRecord(
    String taxiPlateNumber,
    FieldEntryModel updatedEntry,
    String collectionName,
  ) {
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

  static Future<List<FieldEntryModel>> getPurchaseRecord(
    String taxiPlateNumber,
  ) async {
    try {
      final List<FieldEntryModel> purchaseData = [];
      QuerySnapshot querySnapshot = await _firestore
          .collection(AppConstants.purchaseRecordsCollection)
          .doc(taxiPlateNumber)
          .collection(taxiPlateNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          purchaseData.add(FieldEntryModel.fromJson(data));
        }
        return purchaseData;
      }
      return purchaseData;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, List<FieldEntryModel>>> getAllChecklists(
    String taxiPlateNumber,
  ) async {
    final List<FieldEntryModel> newCarEquipmentRecordCollection = [];
    final List<FieldEntryModel> lftrbRecordCollectionForNewCar = [];
    final List<FieldEntryModel> ltoRecordCollectionForNewCar = [];

    QuerySnapshot newCarEquipmentSnapshot = await _firestore
        .collection(AppConstants.newCarEquipmentRecordCollection)
        .doc(taxiPlateNumber)
        .collection(taxiPlateNumber)
        .get();

    if (newCarEquipmentSnapshot.docs.isNotEmpty) {
      for (var doc in newCarEquipmentSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        newCarEquipmentRecordCollection.add(FieldEntryModel.fromJson(data));
      }
    }
    QuerySnapshot lftrbSnapshot = await _firestore
        .collection(AppConstants.lftrbRecordCollectionForNewCar)
        .doc(taxiPlateNumber)
        .collection(taxiPlateNumber)
        .get();

    if (lftrbSnapshot.docs.isNotEmpty) {
      for (var doc in lftrbSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        lftrbRecordCollectionForNewCar.add(FieldEntryModel.fromJson(data));
      }
    }

    QuerySnapshot ltoSnapshot = await _firestore
        .collection(AppConstants.ltoRecordCollectionForNewCar)
        .doc(taxiPlateNumber)
        .collection(taxiPlateNumber)
        .get();

    if (ltoSnapshot.docs.isNotEmpty) {
      for (var doc in ltoSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        ltoRecordCollectionForNewCar.add(FieldEntryModel.fromJson(data));
      }
    }

    final purchaseData = {
      'newCarEquipmentData': newCarEquipmentRecordCollection,
      'ltfrbData': lftrbRecordCollectionForNewCar,
      'ltoData': ltoRecordCollectionForNewCar,
    };
    return purchaseData;
  }

  static Future<void> updateTaxiPlateNumber(
    String oldPlateNumber,
    String newPlateNumber,
    final List<String> collectionNames,
  ) async {
    try {
      for (var collectionName in collectionNames) {
        final oldDocRef = _firestore
            .collection(collectionName)
            .doc(oldPlateNumber);
        final newDocRef = _firestore
            .collection(collectionName)
            .doc(newPlateNumber);

        final oldDocSnapshot = await oldDocRef.get();
        if (oldDocSnapshot.exists) {
          await newDocRef.set(oldDocSnapshot.data()!);

          final subCollectionSnapshot = await oldDocRef
              .collection(oldPlateNumber)
              .get();
          for (var doc in subCollectionSnapshot.docs) {
            await newDocRef
                .collection(newPlateNumber)
                .doc(doc.id)
                .set(doc.data());
          }
          for (var doc in subCollectionSnapshot.docs) {
            await oldDocRef.collection(oldPlateNumber).doc(doc.id).delete();
          }
          await oldDocRef.delete();
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
