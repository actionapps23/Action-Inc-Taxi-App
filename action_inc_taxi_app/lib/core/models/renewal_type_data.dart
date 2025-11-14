class RenewalTypeData {
  final String label;
  final int dateUtc;
  final int periodMonths;
  final int createdAtUtc;
  RenewalTypeData({
    required this.label,
    required this.dateUtc,
    required this.periodMonths,
    required this.createdAtUtc,
  });


Map<String , dynamic> toMap() => {
        'label': label,
        'dateUtc': dateUtc,
        'periodMonths': periodMonths,
        'createdAtUtc': createdAtUtc,
      };

  factory RenewalTypeData.fromMap(Map<String, dynamic> m) => RenewalTypeData(
        label: (m['label'] as String?) ?? '',
        dateUtc: (m['dateUtc'] as int?) ?? DateTime.now().toUtc().millisecondsSinceEpoch,
        periodMonths: (m['periodMonths'] as int?) ?? 6,
        createdAtUtc: (m['createdAtUtc'] as int?) ?? DateTime.now().toUtc().millisecondsSinceEpoch,
      );
}