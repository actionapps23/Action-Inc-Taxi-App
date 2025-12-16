class SectionModel {
  final String sectionName;
  final List<FieldModel> fields;
  const SectionModel({required this.sectionName, required this.fields});
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
}
