import 'enums.dart';

class RenewalTypeData {
  final int? dateUtc;
  final int? periodMonths;
  final int? feesCents;
  final RenewalStatus status;

  RenewalTypeData({
    this.dateUtc,
    this.periodMonths,
    this.feesCents,
    this.status = RenewalStatus.future,
  });

  Map<String, dynamic> toMap() => {
    'dateUtc': dateUtc,
    'periodMonths': periodMonths,
    'feesCents': feesCents,
    'status': status.name,
  };

  factory RenewalTypeData.fromMap(Map<String, dynamic> m) => RenewalTypeData(
    dateUtc: m['dateUtc'] as int?,
    periodMonths: m['periodMonths'] as int?,
    feesCents: m['feesCents'] as int?,
    status: m['status'] != null
        ? RenewalStatus.values.firstWhere(
            (e) => e.name == m['status'],
            orElse: () => RenewalStatus.future,
          )
        : RenewalStatus.future,
  );

  RenewalTypeData copyWith({
    int? dateUtc,
    int? periodMonths,
    int? feesCents,
    RenewalStatus? status,
  }) {
    return RenewalTypeData(
      dateUtc: dateUtc ?? this.dateUtc,
      periodMonths: periodMonths ?? this.periodMonths,
      feesCents: feesCents ?? this.feesCents,
      status: status ?? this.status,
    );
  }
}
