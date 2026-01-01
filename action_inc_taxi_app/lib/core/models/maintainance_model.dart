class MaintainanceModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? taxiId;
  final String? taxiPlateNumber;
  final String? taxiRegistrationNumber;
  final String inspectedBy;
  final String? assignedTo;
  final List<String>? attachmentUrls;
  final bool isResolved;
  final String lastUpdatedBy;
  final DateTime lastUpdatedAt;

  MaintainanceModel({
    this.assignedTo,
    this.attachmentUrls,
    this.isResolved = false,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.taxiId,
    required this.taxiPlateNumber,
    required this.taxiRegistrationNumber,
    required this.inspectedBy,
    required this.lastUpdatedBy,
    required this.lastUpdatedAt,
  });

  MaintainanceModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? taxiId,
    String? taxiPlateNumber,
    String? taxiRegistrationNumber,
    String? inspectedBy,
    String? assignedTo,
    List<String>? attachmentUrls,
    bool? isResolved,
    String? lastUpdatedBy,
    DateTime? lastUpdatedAt,
  }) {
    return MaintainanceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      taxiId: taxiId ?? this.taxiId,
      taxiPlateNumber: taxiPlateNumber ?? this.taxiPlateNumber,
      taxiRegistrationNumber:
          taxiRegistrationNumber ?? this.taxiRegistrationNumber,
      inspectedBy: inspectedBy ?? this.inspectedBy,
      assignedTo: assignedTo ?? this.assignedTo,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      isResolved: isResolved ?? this.isResolved,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'taxiId': taxiId,
      'taxiPlateNumber': taxiPlateNumber,
      'taxiRegistrationNumber': taxiRegistrationNumber,
      'inspectedBy': inspectedBy,
      'assignedTo': assignedTo,
      'attachmentUrls': attachmentUrls,
      'isResolved': isResolved,
      'lastUpdatedBy': lastUpdatedBy,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  factory MaintainanceModel.fromJson(Map<String, dynamic> json) {
    return MaintainanceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      taxiId: json['taxiId'],
      taxiPlateNumber: json['taxiPlateNumber'],
      taxiRegistrationNumber: json['taxiRegistrationNumber'],
      inspectedBy: json['inspectedBy'],
      assignedTo: json['assignedTo'],
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      isResolved: json['isResolved'] ?? false,
      lastUpdatedBy: json['lastUpdatedBy'],
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }
}
