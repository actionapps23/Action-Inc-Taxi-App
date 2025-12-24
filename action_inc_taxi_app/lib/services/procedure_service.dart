import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/procedure_model.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';
import 'package:action_inc_taxi_app/features/open_procedure/procedure_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProcedureService {
  static final String procedureRecords = 'procedures_reocords';
  static final String procedureCheckList = 'procedure_checklist';
  static final String openProcedureChecklist = 'open_procedure_checklist';
  static final String closeProcedureChecklist = 'close_procedure_checklist';

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> submitProcedureRecord(ProcedureModel procedure) async {
    await _firestore
        .collection(procedureRecords)
        .doc(procedure.procedureType)
        .set({'updatedAt': FieldValue.serverTimestamp()});
    final dateKey = HelperFunctions.generateDateKeyFromUtc(
      DateTime.now().toUtc().millisecondsSinceEpoch,
    );
    await _firestore
        .collection(procedureRecords)
        .doc(procedure.procedureType)
        .collection('records')
        .doc(dateKey)
        .set(procedure.toJson());
  }

  static Future<ProcedureModel?> fetchProcedureRecord(
    String procedureType,
    String? dateKey,
  ) async {
    dateKey ??= HelperFunctions.generateDateKeyFromUtc(
      DateTime.now().toUtc().millisecondsSinceEpoch,
    );

    DocumentSnapshot documentSnapshot = await _firestore
        .collection(procedureRecords)
        .doc(procedureType)
        .collection('records')
        .doc(dateKey)
        .get();
    if (documentSnapshot.exists) {
      return ProcedureModel.fromJson(
        documentSnapshot.data() as Map<String, dynamic>,
      );
    } else {
      return null;
    }
  }

  static Future<void> updateProcedureChecklist(
    String checklistType,
    CategoryModel category,
  ) async {
    for (FieldModel field in category.fields) {
      await _firestore
          .collection(procedureCheckList)
          .doc(checklistType)
          .collection(category.categoryName)
          .doc(field.fieldKey)
          .set(field.toJson());
    }

    await _firestore.collection(procedureCheckList).doc(checklistType).set({
      'categories': FieldValue.arrayUnion([category.categoryName]),
    }, SetOptions(merge: true));
  }

  static Future<void> deleteProcedureChecklist(
    String checklistType,
    String categoryName,
    String fieldKey,
  ) async {
    await _firestore
        .collection(procedureCheckList)
        .doc(checklistType)
        .collection(categoryName)
        .doc(fieldKey)
        .delete();

    QuerySnapshot categorySnapshot = await _firestore
        .collection(procedureCheckList)
        .doc(checklistType)
        .collection(categoryName)
        .get();

    if (categorySnapshot.docs.isEmpty) {
      await _firestore.collection(procedureCheckList).doc(checklistType).set({
        'categories': FieldValue.arrayRemove([categoryName]),
      }, SetOptions(merge: true));
    }
  }

  static Future<ProcedureModel> fetchProcedureChecklist(
    String checklistType,
  ) async {
    DocumentSnapshot docSnapshot = await _firestore
        .collection(procedureCheckList)
        .doc(checklistType)
        .get();
    if (docSnapshot.exists) {
      final List<String> categoryNames = List<String>.from(
        docSnapshot.get('categories') ?? [],
      );

      List<CategoryModel> categories = [];
      for (String categoryName in categoryNames) {
        QuerySnapshot categorySnapshot = await _firestore
            .collection(procedureCheckList)
            .doc(checklistType)
            .collection(categoryName)
            .get();

        List<FieldModel> fields = categorySnapshot.docs
            .map(
              (doc) => FieldModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();
        categories.add(
          CategoryModel(categoryName: categoryName, fields: fields),
        );
      }

      return ProcedureModel(
        categories: categories,
        procedureType: checklistType,
      );
    } else {
      throw Exception('Checklist not found');
    }
  }
}
