import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/future_purchase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FuturePurchaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFieldEntry(FuturePurchaseModel field) async {
    await _firestore
        .collection(AppConstants.futurePurchaseCollection)
        .doc(AppConstants.futurePurchaseCollection)
        .set({
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    await _firestore
        .collection(AppConstants.futurePurchaseCollection)
        .doc(AppConstants.futurePurchaseCollection)
        .collection(AppConstants.fieldEntryCollectionName)
        .doc(field.id)
        .set(field.toJson());
  }

  Future<void> deleteFieldEntry(String fieldId) async {
    await _firestore
        .collection(AppConstants.futurePurchaseCollection)
        .doc(AppConstants.futurePurchaseCollection)
        .collection(AppConstants.fieldEntryCollectionName)
        .doc(fieldId)
        .delete();
    await _firestore
        .collection(AppConstants.futurePurchaseCollection)
        .doc(AppConstants.futurePurchaseCollection)
        .set({
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<void> updateFieldEntry(FuturePurchaseModel field) async {
    await _firestore
        .collection(AppConstants.futurePurchaseCollection)
        .doc(AppConstants.futurePurchaseCollection)
        .collection(AppConstants.fieldEntryCollectionName)
        .doc(field.id)
        .update(field.toJson());
    await _firestore
        .collection(AppConstants.futurePurchaseCollection)
        .doc(AppConstants.futurePurchaseCollection)
        .set({
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<List<FuturePurchaseModel>> getFieldEntries() async {
    QuerySnapshot snapshot = await _firestore
        .collection(AppConstants.futurePurchaseCollection)
        .doc(AppConstants.futurePurchaseCollection)
        .collection(AppConstants.fieldEntryCollectionName)
        .get();
    return snapshot.docs
        .map(
          (doc) =>
              FuturePurchaseModel.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }
}
