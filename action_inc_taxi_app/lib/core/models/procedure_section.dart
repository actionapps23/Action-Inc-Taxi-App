// import 'procedure_field.dart';

// class ProcedureSection {
//   String id;
//   String name;
//   List<ProcedureField> fields;

//   ProcedureSection({
//     required this.id,
//     required this.name,
//     required this.fields,
//   });
//   // copy With
//   ProcedureSection copyWith({
//     String? id,
//     String? name,
//     List<ProcedureField>? fields,
//   }) {
//     return ProcedureSection(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       fields: fields ?? this.fields,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'fields': fields.map((field) => field.toJson()).toList(),
//     };
//   }

//   factory ProcedureSection.fromJson(Map<String, dynamic> json) {
//     return ProcedureSection(
//       id: json['id'],
//       name: json['name'],
//       fields: (json['fields'] as List<dynamic>)
//           .map((fieldJson) => ProcedureField.fromJson(fieldJson))
//           .toList(),
//     );
//   }
// }
