class Driver {
  final String id;
  final String firstDriverName;
  final String firstDriverCnic;
  final int? firstDriverDobUtc;
  final String? secondDriverName;
  final String? secondDriverCnic;
  final int? secondDriverDobUtc;
  final int createdAtUtc;

  Driver({
    required this.id,
    required this.firstDriverName,
    required this.firstDriverCnic,
    this.firstDriverDobUtc,
    this.secondDriverName,
    this.secondDriverCnic,
    this.secondDriverDobUtc,
    required this.createdAtUtc,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'firstDriverName': firstDriverName,
    'firstDriverCnic': firstDriverCnic,
    'firstDriverDobUtc': firstDriverDobUtc,
    'secondDriverName': secondDriverName,
    'secondDriverCnic': secondDriverCnic,
    'secondDriverDobUtc': secondDriverDobUtc,
    'createdAtUtc': createdAtUtc,
  };

  factory Driver.fromMap(Map<String, dynamic> m) => Driver(
    id: m['id'] as String,
    firstDriverName: m['firstDriverName'] as String? ?? '',
    firstDriverCnic: m['firstDriverCnic'] as String? ?? '',
    firstDriverDobUtc: m['firstDriverDobUtc'] as int?,
    secondDriverName: m['secondDriverName'] as String?,
    secondDriverCnic: m['secondDriverCnic'] as String?,
    secondDriverDobUtc: m['secondDriverDobUtc'] as int?,
    createdAtUtc:
        (m['createdAtUtc'] as int?) ??
        DateTime.now().toUtc().millisecondsSinceEpoch,
  );
}
