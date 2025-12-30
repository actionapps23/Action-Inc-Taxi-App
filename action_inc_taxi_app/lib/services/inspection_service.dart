import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionService {
  static final String inspectionCollection = 'inspections';
  static final String categoryCollection = 'categories';
  static final String fieldEntryCollection = 'field_entries';

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> submitInspectionData(
    String plateNumber,
    String view,
    List<CategoryModel> categories,
  ) async {
    await _firestore.collection(inspectionCollection).doc(plateNumber).set({
      'taxi_id': plateNumber,
    });

    for (CategoryModel category in categories) {
      await _firestore
          .collection(inspectionCollection)
          .doc(plateNumber)
          .collection(view)
          .doc(view)
          .set({
            'last_updated': DateTime.now(),
            'subCategories': FieldValue.arrayUnion([
              HelperFunctions.getKeyFromTitle(category.categoryName),
            ]),
          }, SetOptions(merge: true));
      for (var section in category.fields) {
        await _firestore
            .collection(inspectionCollection)
            .doc(plateNumber)
            .collection(view)
            .doc(view)
            .collection(HelperFunctions.getKeyFromTitle(category.categoryName))
            .doc(section.fieldKey)
            .set(section.toJson());
      }
    }
  }

  static Future<List<CategoryModel>> fetchSubmittedInspectionData(
    String plateNumber,
    String view,
  ) async {
    List<CategoryModel> categories = [];

    final DocumentSnapshot documentSnapshot = await _firestore
        .collection(inspectionCollection)
        .doc(plateNumber)
        .collection(view)
        .doc(view)
        .get();

    if (documentSnapshot.exists) {
      List<dynamic> subCategoriesKey =
          documentSnapshot.get('subCategories') ?? [];
      for (String subCategoryKey in subCategoriesKey) {
        List<FieldModel> fields = [];
        final QuerySnapshot categorySnapshot = await _firestore
            .collection(inspectionCollection)
            .doc(plateNumber)
            .collection(view)
            .doc(view)
            .collection(subCategoryKey)
            .get();

        for (var doc in categorySnapshot.docs) {
          FieldModel fieldModel = FieldModel.fromJson(
            doc.data() as Map<String, dynamic>,
          );
          fields.add(fieldModel);
        }
        String categoryName = HelperFunctions.getTitleFromKey(subCategoryKey);
        categories.add(
          CategoryModel(categoryName: categoryName, fields: fields),
        );
      }
    }
    return categories;
  }

  static Future<void> updateInspectionChecklist({
    required String plateNumber,
    required String view,
    required CategoryModel category,
  }) async {
    try {
      await submitInspectionData(plateNumber, view, [category]);
    } catch (e) {
      rethrow;
    }
  }
}
