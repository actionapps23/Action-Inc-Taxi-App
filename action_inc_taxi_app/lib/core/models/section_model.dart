class CategoryModel {
  final String categoryName;
  final List<FieldModel> fields;
  const CategoryModel({required this.categoryName, required this.fields});

  CategoryModel copyWith({String? categoryName, List<FieldModel>? fields}) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      fields: fields ?? this.fields,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }

  CategoryModel.fromJson(Map<String, dynamic> json)
    : categoryName = json['categoryName'],
      fields = (json['fields'] as List<dynamic>)
          .map((fieldJson) => FieldModel.fromJson(fieldJson))
          .toList();
}

class FieldModel {
  final String fieldName;
  final String fieldKey;
  final bool isChecked;
  const FieldModel({
    required this.fieldName,
    required this.fieldKey,
    this.isChecked = false,
  });

  FieldModel copyWith({String? fieldName, String? fieldKey, bool? isChecked}) {
    return FieldModel(
      fieldName: fieldName ?? this.fieldName,
      fieldKey: fieldKey ?? this.fieldKey,
      isChecked: isChecked ?? this.isChecked,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'fieldKey': fieldKey,
      'isChecked': isChecked,
    };
  }

  FieldModel.fromJson(Map<String, dynamic> json)
    : fieldName = json['fieldName'],
      fieldKey = json['fieldKey'],
      isChecked = json['isChecked'];
}
