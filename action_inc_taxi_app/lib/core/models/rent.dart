class Rent {
  final String? id;
  final String taxiNo;
  final String? driverId;
  final int dateUtc;
  final int? contractStartUtc;
  final int? contractEndUtc;
  final int monthsCount;
  final int extraDays;
  final int rentAmountCents;
  final int maintenanceFeesCents;
  final int carWashFeesCents;
  final int paymentCashCents;
  final int paymentGCashCents;
  final String? gCashRef;
  final bool isPublicHoliday;
  final bool isBirthday;
  final int createdAtUtc;

  Rent({
    this.id,
    required this.taxiNo,
    this.driverId,
    required this.dateUtc,
    this.contractStartUtc,
    this.contractEndUtc,
    this.monthsCount = 0,
    this.extraDays = 0,
    required this.rentAmountCents,
    required this.maintenanceFeesCents,
    required this.carWashFeesCents,
    required this.paymentCashCents,
    required this.paymentGCashCents,
    this.gCashRef,
    this.isPublicHoliday = false,
    this.isBirthday = false,
    required this.createdAtUtc,
  });

  int get totalCents =>
      rentAmountCents + maintenanceFeesCents + carWashFeesCents;

  int get dueRentCents => totalCents - (paymentCashCents + paymentGCashCents);

  Map<String, dynamic> toMap() => {
    'id': id,
    'taxiNo': taxiNo,
    'driverId': driverId,
    'dateUtc': dateUtc,
    'contractStartUtc': contractStartUtc,
    'contractEndUtc': contractEndUtc,
    'monthsCount': monthsCount,
    'extraDays': extraDays,
    'rentAmountCents': rentAmountCents,
    'maintenanceFeesCents': maintenanceFeesCents,
    'carWashFeesCents': carWashFeesCents,
    'paymentCashCents': paymentCashCents,
    'paymentGCashCents': paymentGCashCents,
    'gCashRef': gCashRef,
    'isPublicHoliday': isPublicHoliday,
    'isBirthday': isBirthday,
    'createdAtUtc': createdAtUtc,
  };

  factory Rent.fromMap(Map<String, dynamic> m) => Rent(
    id: m['id'] as String?,
    taxiNo: m['taxiNo'] as String,
    driverId: m['driverId'] as String?,
    dateUtc:
        (m['dateUtc'] as int?) ?? DateTime.now().toUtc().millisecondsSinceEpoch,
    contractStartUtc: (m['contractStartUtc'] as int?),
    contractEndUtc: (m['contractEndUtc'] as int?),
    monthsCount: (m['monthsCount'] as int?) ?? 0,
    extraDays: (m['extraDays'] as int?) ?? 0,
    rentAmountCents: (m['rentAmountCents'] as int?) ?? 0,
    maintenanceFeesCents: (m['maintenanceFeesCents'] as int?) ?? 0,
    carWashFeesCents: (m['carWashFeesCents'] as int?) ?? 0,
    paymentCashCents: (m['paymentCashCents'] as int?) ?? 0,
    paymentGCashCents: (m['paymentGCashCents'] as int?) ?? 0,
    gCashRef: m['gCashRef'] as String?,
    isPublicHoliday: (m['isPublicHoliday'] as bool?) ?? false,
    isBirthday: (m['isBirthday'] as bool?) ?? false,
    createdAtUtc:
        (m['createdAtUtc'] as int?) ??
        DateTime.now().toUtc().millisecondsSinceEpoch,
  );

  Map<String, String> validate() {
    final errors = <String, String>{};
    if (taxiNo.isEmpty) errors['taxiNo'] = 'Taxi number is required.';
    if (rentAmountCents < 0) errors['rentAmount'] = 'Rent must be >= 0.';
    if (maintenanceFeesCents < 0)
      errors['maintenanceFees'] = 'Maintenance must be >= 0.';
    if (carWashFeesCents < 0) errors['carWashFees'] = 'Car wash must be >= 0.';
    if (paymentCashCents < 0) errors['paymentCash'] = 'Payment must be >= 0.';
    if (paymentGCashCents < 0) errors['paymentGCash'] = 'Payment must be >= 0.';
    if (paymentCashCents + paymentGCashCents > totalCents)
      errors['payments'] = 'Collected amount cannot exceed total.';
    if (extraDays < 0) errors['extraDays'] = 'Extra days cannot be negative.';
    if (contractStartUtc != null && contractEndUtc != null) {
      if (contractEndUtc! < contractStartUtc!)
        errors['contractDates'] = 'Contract end must be after start.';
    }
    return errors;
  }

  /// Helper: compute months count given start and end timestamps (UTC ms).
  /// Calculates the exact number of months between two dates.
  static int computeMonthsCountFromTimestamps(int? startUtc, int? endUtc) {
    if (startUtc == null || endUtc == null) return 0;
    final start = DateTime.fromMillisecondsSinceEpoch(startUtc, isUtc: true);
    final end = DateTime.fromMillisecondsSinceEpoch(endUtc, isUtc: true);
    if (!end.isAfter(start)) return 0;
    
    int months = (end.year - start.year) * 12;
    months += (end.month - start.month);
    
    // If the end day is before the start day, subtract 1 month
    if (end.day < start.day) {
      months--;
    }
    
    return months;
  }
}
