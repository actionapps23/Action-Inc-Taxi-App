class SectionModel {
  final String sectionName;
  final List<FieldModel> fields;
  SectionModel({required this.sectionName, required this.fields});
}

class FieldModel {
  final String fieldName;
  final bool isChecked;
  FieldModel({required this.fieldName, this.isChecked = false});
}
