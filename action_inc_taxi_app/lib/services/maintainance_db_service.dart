import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaintainanceDbService {
  static final maintainanceCollection = 'maintainance';
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Future<void> addMaintainanceRequest(MaintainanceModel model) async {
    await _firebaseFirestore
        .collection(maintainanceCollection)
        .doc(model.id)
        .set(model.toJson());
  }

  static Future<List<MaintainanceModel>> fetchMaintainanceRequests() async {
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(maintainanceCollection)
        .get();

    return snapshot.docs.map((doc) {
      return MaintainanceModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  static Future<void> updateMaintainanceRequest(MaintainanceModel model) async {
    await _firebaseFirestore
        .collection(maintainanceCollection)
        .doc(model.id)
        .update(model.toJson());
  }

  static Future<void> deleteMaintainanceRequest(String id) async {
    await _firebaseFirestore
        .collection(maintainanceCollection)
        .doc(id)
        .delete();
  }
}
