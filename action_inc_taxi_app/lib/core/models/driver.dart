class Driver {
  final String id;
  final String name;
  final int? dobUtc;
  final String? idCardNo;
  final int createdAtUtc;

  Driver({
    required this.id,
    required this.name,
    this.dobUtc,
    this.idCardNo,
    required this.createdAtUtc,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'dobUtc': dobUtc,
    'idCardNo': idCardNo,
    'createdAtUtc': createdAtUtc,
  };

  factory Driver.fromMap(Map<String, dynamic> m) => Driver(
    id: m['id'] as String,
    name: m['name'] as String? ?? '',
    dobUtc: m['dobUtc'] as int?,
    idCardNo: m['idCardNo'] as String?,
    createdAtUtc:
        (m['createdAtUtc'] as int?) ??
        DateTime.now().toUtc().millisecondsSinceEpoch,
  );
}
