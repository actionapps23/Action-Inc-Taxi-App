// ignore_for_file: non_constant_identifier_names

import 'package:action_inc_taxi_app/core/helper_functions.dart';

class FieldEntryModel {
  final String id;
  final String title;
  final int SOP;
  final int fees;
  final bool isCompleted;
  final DateTime timeline;
  final DateTime lastUpdated;

  FieldEntryModel({
    String? id,
    required this.title,
    required this.SOP,
    required this.fees,
    required this.timeline,
    required this.isCompleted,
    DateTime? lastUpdated,
  }) : id = id ?? HelperFunctions.getKeyFromTitle(title),
       lastUpdated = lastUpdated ?? DateTime.now();

  FieldEntryModel copyWith({
    String? id,
    String? title,
    int? SOP,
    int? fees,
    DateTime? timeline,
    bool? isCompleted,
    DateTime? lastUpdated,
  }) {
    return FieldEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      SOP: SOP ?? this.SOP,
      fees: fees ?? this.fees,
      isCompleted: isCompleted ?? this.isCompleted,
      timeline: timeline ?? this.timeline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'SOP': SOP,
      'fees': fees,
      'isCompleted': isCompleted,
      'timeline': timeline.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory FieldEntryModel.fromJson(Map<String, dynamic> json) {
    return FieldEntryModel(
      id: json['id'],
      title: json['title'],
      SOP: json['SOP'],
      fees: json['fees'],
      isCompleted: json['isCompleted'],
      timeline: DateTime.parse(json['timeline']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
