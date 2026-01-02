import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  final String employeeId;
  final String name;
  final String password;
  final String role;
  final bool isAdmin;
  final DateTime? createdAt;
  final String? token;

  EmployeeModel({
    required this.employeeId,
    required this.name,
    required this.password,
    required this.role,
    required this.isAdmin,
    this.createdAt,
    this.token,
  });

  EmployeeModel copyWith({
    String? employeeId,
    String? name,
    String? password,
    String? role,
    bool? isAdmin,
    DateTime? createdAt,
    String? token,
  }) {
    return EmployeeModel(
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      password: password ?? this.password,
      role: role ?? this.role,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
    );
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['employeeId'] as String,
      token: json['token'] as String?,
      name: json['name'] as String,
      password: json['hashPassword'] as String,
      role: json['role'] as String,
      isAdmin: json['isAdmin'] as bool,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'name': name,
      'token': token,
      'hashPassword': password,
      'role': role,
      'isAdmin': isAdmin,
      'createdAt': createdAt,
    };
  }
}
