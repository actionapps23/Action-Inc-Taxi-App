import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> savePurchaseRecord(
    String taxiPlateNumber,
    List<FieldEntryModel> purchaseData,
  ) async {
    try {
      await _firestore
          .collection(AppConstants.purchaseCollection)
          .doc(taxiPlateNumber)
          .set({'last_updated': FieldValue.serverTimestamp()});

      for (var i in purchaseData) {
        await _firestore
            .collection(AppConstants.purchaseCollection)
            .doc(taxiPlateNumber)
            .collection(taxiPlateNumber)
            .doc(i.id)
            .set(i.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<FieldEntryModel>> getPurchaseRecord(String taxiPlateNumber) async {
    try {
      final List<FieldEntryModel> purchaseData = [];
      QuerySnapshot querySnapshot = await _firestore
          .collection(AppConstants.purchaseCollection)
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
}
