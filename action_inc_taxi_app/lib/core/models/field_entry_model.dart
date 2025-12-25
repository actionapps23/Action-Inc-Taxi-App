// ignore_for_file: non_constant_identifier_names

class FieldEntryModel {
  final String id;
  final String title;
  final int SOP;
  final int price;
  final DateTime timeline;
  final DateTime lastUpdated;

  FieldEntryModel({
    required this.id,
    required this.title,
    required this.SOP,
    required this.price,
    required this.timeline,
    required this.lastUpdated,
  });

  FieldEntryModel copyWith({
    String? id,
    String? title,
    int? SOP,
    int? price,
    DateTime? timeline,
    DateTime? lastUpdated,
  }) {
    return FieldEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      SOP: SOP ?? this.SOP,
      price: price ?? this.price,
      timeline: timeline ?? this.timeline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'SOP': SOP,
      'price': price,
      'timeline': timeline.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory FieldEntryModel.fromJson(Map<String, dynamic> json) {
    return FieldEntryModel(
      id: json['id'],
      title: json['title'],
      SOP: json['SOP'],
      price: json['price'],
      timeline: DateTime.parse(json['timeline']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
