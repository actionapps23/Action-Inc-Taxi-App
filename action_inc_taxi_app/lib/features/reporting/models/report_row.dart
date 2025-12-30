class ReportRow {
  final DateTime date;
  final String plateNumber;
  final String vehicleModel;
  final String driverName;
  final String cleanliness;
  final String remarks;

  ReportRow({
    required this.date,
    required this.plateNumber,
    required this.vehicleModel,
    required this.driverName,
    required this.cleanliness,
    required this.remarks,
  });

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'plateNumber': plateNumber,
        'vehicleModel': vehicleModel,
        'driverName': driverName,
        'cleanliness': cleanliness,
        'remarks': remarks,
      };

  factory ReportRow.fromMap(Map<String, dynamic> m) => ReportRow(
        date: DateTime.parse(m['date'] as String),
        plateNumber: m['plateNumber'] as String,
        vehicleModel: m['vehicleModel'] as String,
        driverName: m['driverName'] as String,
        cleanliness: m['cleanliness'] as String,
        remarks: m['remarks'] as String,
      );
}
