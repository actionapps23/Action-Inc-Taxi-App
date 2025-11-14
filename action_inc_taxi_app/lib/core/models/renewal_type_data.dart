class RenewalTypeData {
  final int? dateUtc;
  final int? periodMonths;
  final int? feesCents;

  RenewalTypeData({
    this.dateUtc,
    this.periodMonths,
    this.feesCents,
  });

  Map<String, dynamic> toMap() => {
        'dateUtc': dateUtc,
        'periodMonths': periodMonths,
        'feesCents': feesCents,
      };

  factory RenewalTypeData.fromMap(Map<String, dynamic> m) => RenewalTypeData(
        dateUtc: m['dateUtc'] as int?,
        periodMonths: m['periodMonths'] as int?,
        feesCents: m['feesCents'] as int?,
      );

  RenewalTypeData copyWith({
    int? dateUtc,
    int? periodMonths,
    int? feesCents,
  }) {
    return RenewalTypeData(
      dateUtc: dateUtc ?? this.dateUtc,
      periodMonths: periodMonths ?? this.periodMonths,
      feesCents: feesCents ?? this.feesCents,
    );
  }
}