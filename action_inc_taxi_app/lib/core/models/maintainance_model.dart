class MaintainanceModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String taxiId;
  final String fleetId;
  final String inspectedBy;
  final String? assignedTo;
  final List<String>? attachmentUrls;

  MaintainanceModel({
    this.assignedTo,
    this.attachmentUrls,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.taxiId,
    required this.fleetId,
    required this.inspectedBy,
  });

  MaintainanceModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? taxiId,
    String? fleetId,
    String? inspectedBy,
    String? assignedTo,
    List<String>? attachmentUrls,
  }) {
    return MaintainanceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      taxiId: taxiId ?? this.taxiId,
      fleetId: fleetId ?? this.fleetId,
      inspectedBy: inspectedBy ?? this.inspectedBy,
      assignedTo: assignedTo ?? this.assignedTo,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'taxiId': taxiId,
      'fleetId': fleetId,
      'inspectedBy': inspectedBy,
      'assignedTo': assignedTo,
      'attachmentUrls': attachmentUrls,
    };
  }

  factory MaintainanceModel.fromJson(Map<String, dynamic> json) {
    return MaintainanceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      taxiId: json['taxiId'],
      fleetId: json['fleetId'],
      inspectedBy: json['inspectedBy'],
      assignedTo: json['assignedTo'],
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
    );
  }
}
