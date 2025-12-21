class MaintainanceModel {
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
    required this.title,
    required this.description,
    required this.date,
    required this.taxiId,
    required this.fleetId,
    required this.inspectedBy,
    required this.attachmentUrls,
  });
}
