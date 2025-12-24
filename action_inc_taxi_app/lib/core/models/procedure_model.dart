
import 'package:action_inc_taxi_app/core/models/section_model.dart';

class ProcedureModel {
  String id;
  List<CategoryModel> categories;

  ProcedureModel({
    String? id,
    required this.categories,
  }) : id = id ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }

  factory ProcedureModel.fromJson(Map<String, dynamic> json) {
    return ProcedureModel(
      id: json['id'],
      categories: (json['categories'] as List<dynamic>)
          .map((categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList(),
    );
  }
  
}