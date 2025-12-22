import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:action_inc_taxi_app/core/models/employeee_model.dart';

class EmployeeService {
  static final String employeeCollection = 'employees';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addEmployee(EmployeeModel employee) async {
    final data = employee.toJson();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _firestore
        .collection(employeeCollection)
        .doc(employee.employeeId)
        .set(data);
  }

  static Future<List<EmployeeModel>> fetchAllEmployees() async {
    final snapshot = await _firestore.collection(employeeCollection).get();
    return snapshot.docs
        .map((doc) => EmployeeModel.fromJson(doc.data()))
        .toList();
  }

  static Future<String> getNextEmployeeId() async {
    final snapshot = await _firestore.collection(employeeCollection).get();
    int maxId = 0;
    for (var doc in snapshot.docs) {
      final id = doc['employeeId'] as String;
      final numPart = int.tryParse(id.replaceAll('emp', '')) ?? 0;
      if (numPart > maxId) maxId = numPart;
    }
    final nextId = maxId + 1;
    return 'emp${nextId.toString().padLeft(3, '0')}';
  }
}
