class Renewal {
  final String? id;
  final String taxiNo;
  final String label; // e.g. 'LTEFB Renewal'
  final int dateUtc; // when the renewal is due (UTC ms)
  final int periodMonths; // stored as int (e.g., 6)
  final int feesCents; // stored in cents
  final int createdAtUtc;
  final int? contractStartUtc;
  final int? contractEndUtc;

  Renewal({
    this.id,
    required this.taxiNo,
    required this.label,
    required this.dateUtc,
    required this.periodMonths,
    required this.feesCents,
    required this.createdAtUtc,
    this.contractStartUtc,
    this.contractEndUtc,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'taxiNo': taxiNo,
    'label': label,
    'dateUtc': dateUtc,
    'periodMonths': periodMonths,
    'feesCents': feesCents,
    'createdAtUtc': createdAtUtc,
    'contractStartUtc': contractStartUtc,
    'contractEndUtc': contractEndUtc,
  };

  factory Renewal.fromMap(Map<String, dynamic> m) => Renewal(
    id: m['id'] as String?,
    taxiNo: m['taxiNo'] as String,
    label: m['label'] as String? ?? '',
    dateUtc:
        (m['dateUtc'] as int?) ?? DateTime.now().toUtc().millisecondsSinceEpoch,
    periodMonths: (m['periodMonths'] as int?) ?? 6,
    feesCents: (m['feesCents'] as int?) ?? 0,
    createdAtUtc:
        (m['createdAtUtc'] as int?) ??
        DateTime.now().toUtc().millisecondsSinceEpoch,
    contractStartUtc: (m['contractStartUtc'] as int?),
    contractEndUtc: (m['contractEndUtc'] as int?),
  );

  Map<String, String> validate() {
    final errors = <String, String>{};
    if (taxiNo.isEmpty) errors['taxiNo'] = 'Taxi number required.';
    if (label.isEmpty) errors['label'] = 'Label required.';
    if (periodMonths <= 0) errors['periodMonths'] = 'Period must be >= 1.';
    if (feesCents < 0) errors['fees'] = 'Fees cannot be negative.';
    return errors;
  }

  String displayPeriodLabel() =>
      'After $periodMonths month${periodMonths == 1 ? '' : 's'}';
}
