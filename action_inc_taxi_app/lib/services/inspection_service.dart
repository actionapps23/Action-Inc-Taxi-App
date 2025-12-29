import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionService {
  static final String inspectionCollection = 'inspections';
  static final String categoryCollection = 'categories';
  static final String fieldEntryCollection = 'field_entries';

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> submitInspectionData(
    String taxiID,
    String view,
    List<CategoryModel> categories,
  ) async {
    await _firestore.collection(inspectionCollection).doc(taxiID).set({
      'taxi_id': taxiID,
    });

    for (CategoryModel category in categories) {
      for (var section in category.fields) {
        await _firestore
            .collection(inspectionCollection)
            .doc(taxiID)
            .collection(view)
            .doc(view)
            .set({'last_updated': DateTime.now()});
        
        await _firestore.
        collection(inspectionCollection)
            .doc(taxiID)
            .collection(view)
            .doc(view).
            collection(HelperFunctions.getKeyFromTitle(category.categoryName))
            .doc(section.fieldKey)
            .set(section.toJson());
           
      }
    }
  }

  static Future<List<CategoryModel>>  fetchSubmittedInspectionData(String taxiID, String view) async {
    List<CategoryModel> categories = [];

    final querySnapshot = await _firestore
        .collection(inspectionCollection)
        .doc(taxiID)
        .collection(view)
        .get();

    for (var doc in querySnapshot.docs) {
      categories.add(CategoryModel.fromJson(doc.data()));
    }

    return categories;
  }
  
}
