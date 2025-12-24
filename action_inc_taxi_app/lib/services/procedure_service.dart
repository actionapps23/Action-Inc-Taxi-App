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
        .doc(procedure.id)
        .set(procedure.toJson());
  }

  static Future<void> updateProcedureChecklist(
    String checklistType,
    CategoryModel category,
  ) async {
    await _firestore
        .collection(procedureCheckList)
        .doc(checklistType)
        .collection(category.categoryName)
        .add(category.toJson());

    await _firestore.collection(procedureCheckList).doc(checklistType).set({
      'categories': FieldValue.arrayUnion([category.categoryName]),
    }, SetOptions(merge: true));
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

      return ProcedureModel(id: docSnapshot.id, categories: categories);
    } else {
      throw Exception('Checklist not found');
    }
  }
}
