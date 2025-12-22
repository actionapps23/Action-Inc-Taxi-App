class MaintainanceModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String taxiId;
  final String fleetId;
  final String inspectedBy;
  final String? assignedTo;
  final List<String> attachmentUrls;

  MaintainanceModel({
    this.assignedTo,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.taxiId,
    required this.fleetId,
    required this.inspectedBy,
    required this.attachmentUrls,
  });

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
