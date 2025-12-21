class CategoryModel {
  final String categoryName;
  final List<FieldModel> fields;
  const CategoryModel({required this.categoryName, required this.fields});
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
