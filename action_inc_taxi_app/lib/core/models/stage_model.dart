import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';

class StageModel {
  final String id;
  final List<FieldEntryModel> fieldEntries;

  StageModel({required this.id, required this.fieldEntries});

  StageModel copyWith({String? id, List<FieldEntryModel>? fieldEntries}) {
    return StageModel(
      id: id ?? this.id,
      fieldEntries: fieldEntries ?? this.fieldEntries,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fieldEntries': fieldEntries.map((entry) => entry.toJson()).toList(),
    };
  }

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json['id'],
      fieldEntries: (json['fieldEntries'] as List<dynamic>)
          .map((entryJson) => FieldEntryModel.fromJson(entryJson))
          .toList(),
    );
  }
}
