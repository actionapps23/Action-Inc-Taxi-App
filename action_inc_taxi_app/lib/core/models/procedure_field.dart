// class ProcedureField {
//   String id;
//   String name;
//   bool isChecked;

//   ProcedureField({
//     required this.id,
//     required this.name,
//     this.isChecked = false,
//   });

//   // copy With
//   ProcedureField copyWith({
//     String? id,
//     String? name,
//     bool? isChecked,
//   }) {
//     return ProcedureField(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       isChecked: isChecked ?? this.isChecked,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'isChecked': isChecked,
//     };
//   }

//   factory ProcedureField.fromJson(Map<String, dynamic> json) {
//     return ProcedureField(
//       id: json['id'],
//       name: json['name'],
//       isChecked: json['isChecked'],
//     );
//   }
// }
