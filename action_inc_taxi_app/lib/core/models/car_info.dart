class CarInfo {
  final String id;
  final String taxiNo;
  final String? plateNumber;
  final String? fleetNo;
  final String? driverId;
  final int createdAtUtc;
  final bool onRoad;

  CarInfo({
    required this.id,
    required this.taxiNo,
    this.plateNumber,
    this.fleetNo,
    this.driverId,
    required this.createdAtUtc,
    this.onRoad = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'taxiNo': taxiNo,
    'plateNumber': plateNumber,
    'fleetNo': fleetNo,
    'driverId': driverId,
    'createdAtUtc': createdAtUtc,
    'onRoad': onRoad,
  };

  factory CarInfo.fromMap(Map<String, dynamic> m) => CarInfo(
    id: m['id'] as String,
    taxiNo: m['taxiNo'] as String,
    plateNumber: m['plateNumber'] as String?,
    fleetNo: m['fleetNo'] as String?,
    driverId: m['driverId'] as String?,
    createdAtUtc:
        (m['createdAtUtc'] as int?) ??
        DateTime.now().toUtc().millisecondsSinceEpoch,
    onRoad: (m['onRoad'] as bool?) ?? false,
  );
}
