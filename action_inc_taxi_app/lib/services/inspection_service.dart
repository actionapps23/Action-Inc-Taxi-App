import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionService {
  static final String inspectionCollection = 'inspections';
  static final String inspectionChecklistCollection = 'inspection_checklists';
  static final String categoryCollection = 'categories';
  static final String fieldEntryCollection = 'field_entries';

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addItemToChecklist({
    required String view,
    required CategoryModel category,
  }) async {
    try {
      _firestore.collection(inspectionChecklistCollection).doc(view).set({
        'last_updated': DateTime.now(),
        'subCategories': FieldValue.arrayUnion([
          HelperFunctions.getKeyFromTitle(category.categoryName),
        ]),
      }, SetOptions(merge: true));
      for (var section in category.fields) {
        await _firestore
            .collection(inspectionChecklistCollection)
            .doc(view)
            .collection(HelperFunctions.getKeyFromTitle(category.categoryName))
            .doc(section.fieldKey)
            .set(section.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<CategoryModel>> fetchInspectionChecklist(
    String view,
  ) async {
    List<CategoryModel> categories = [];

    final DocumentSnapshot documentSnapshot = await _firestore
        .collection(inspectionChecklistCollection)
        .doc(view)
        .get();

    if (documentSnapshot.exists) {
      List<dynamic> subCategories = documentSnapshot.get('subCategories') ?? [];

      for (String categoryKey in subCategories) {
        final QuerySnapshot categorySnapshot = await _firestore
            .collection(inspectionChecklistCollection)
            .doc(view)
            .collection(categoryKey)
            .get();

        List<FieldModel> fields = categorySnapshot.docs.map((doc) {
          return FieldModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        categories.add(
          CategoryModel(
            categoryName: HelperFunctions.getTitleFromKey(categoryKey),
            fields: fields,
          ),
        );
      }
    }
    return categories;
  }

  static Future<void> updateCheckList(
    String view,
    CategoryModel category,
  ) async {
    await _firestore.collection(inspectionChecklistCollection).doc(view).set({
      'last_updated': DateTime.now(),
      'subCategories': FieldValue.arrayUnion([
        HelperFunctions.getKeyFromTitle(category.categoryName),
      ]),
    }, SetOptions(merge: true));
    for (var section in category.fields) {
      await _firestore
          .collection(inspectionChecklistCollection)
          .doc(view)
          .collection(HelperFunctions.getKeyFromTitle(category.categoryName))
          .doc(section.fieldKey)
          .set(section.toJson());
    }
  }

  static Future<void> submitInspectionData(
    Map<String, bool> checkedFields,
    String plateNumber,
    String view,
  ) async {
    await _firestore.collection(inspectionCollection).doc(plateNumber).set({
      'last_updated': DateTime.now(),
    }, SetOptions(merge: true));
    for (var entry in checkedFields.entries) {
      await _firestore
          .collection(inspectionCollection)
          .doc(plateNumber)
          .collection(view)
          .doc(entry.key)
          .set({'isChecked': entry.value});
    }
  }

  static Future<Map<String, bool>> fetchSubmittedInspectionData(
    String plateNumber,
    String view,
  ) async {
    Map<String, bool> checkedFieldsFromDB = {};

    final QuerySnapshot dataSnapshot = await _firestore
        .collection(inspectionCollection)
        .doc(plateNumber)
        .collection(view)
        .get();

    for (var doc in dataSnapshot.docs) {
      checkedFieldsFromDB[doc.id] = doc.get('isChecked') ?? false;
    }

    return checkedFieldsFromDB;
  }

  static Future<void> updateInspectionData(
    String plateNumber,
    String view,
    Map<String, bool> checkedFields,
  ) async {
    for (var entry in checkedFields.entries) {
      await _firestore
          .collection(inspectionCollection)
          .doc(plateNumber)
          .collection(view)
          .doc(entry.key)
          .set({'isChecked': entry.value, 'last_updated': DateTime.now()});
    }
  }
}
