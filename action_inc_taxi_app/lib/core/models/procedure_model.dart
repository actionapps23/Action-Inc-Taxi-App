import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/section_model.dart';

class ProcedureModel {
  String id;
  String procedureType;
  List<CategoryModel> categories;

  ProcedureModel({
    String? id,
    required this.procedureType,
    required this.categories,
  }) : id =
           id ??
           HelperFunctions.generateDateKeyFromUtc(
             DateTime.now().toUtc().millisecondsSinceEpoch,
           );

  ProcedureModel copyWith({
    String? id,
    String? procedureType,
    List<CategoryModel>? categories,
  }) {
    return ProcedureModel(
      id: id ?? this.id,
      procedureType: procedureType ?? this.procedureType,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'procedureType': procedureType,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }

  factory ProcedureModel.fromJson(Map<String, dynamic> json) {
    return ProcedureModel(
      id: json['id'],
      procedureType: json['procedureType'],
      categories: (json['categories'] as List<dynamic>)
          .map((categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList(),
    );
  }
}
