import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FieldService {
  final String collectionName;
  final String documentId;
  FieldService({required this.collectionName, required this.documentId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFieldEntry(FieldEntryModel field) async {
    await _firestore.collection(collectionName).doc(documentId).set({
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .collection(AppConstants.fieldEntryCollectionName)
        .doc(field.id)
        .set(field.toJson());
  }

  Future<void> deleteFieldEntry(String fieldId) async {
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .collection(AppConstants.fieldEntryCollectionName)
        .doc(fieldId)
        .delete();
    await _firestore.collection(collectionName).doc(documentId).set({
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateFieldEntry(FieldEntryModel field) async {
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .collection(AppConstants.fieldEntryCollectionName)
        .doc(field.id)
        .update(field.toJson());
    await _firestore.collection(collectionName).doc(documentId).set({
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<FieldEntryModel>> getFieldEntries() async {
    QuerySnapshot snapshot = await _firestore
        .collection(collectionName)
        .doc(documentId)
        .collection(AppConstants.fieldEntryCollectionName)
        .orderBy('timeline', descending: false)
        .get();
    return snapshot.docs
        .map(
          (doc) => FieldEntryModel.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }
}
