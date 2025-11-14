import 'package:action_inc_taxi_app/core/models/renewal_type_data.dart';

class Renewal {

    Renewal copyWith({
      String? id,
      String? taxiNo,
      RenewalTypeData? sealing,
      RenewalTypeData? inspection,
      RenewalTypeData? ltefb,
      RenewalTypeData? registeration,
      RenewalTypeData? drivingLicense,
      RenewalTypeData? lto,
      int? createdAtUtc,
      int? contractStartUtc,
      int? contractEndUtc,
    }) {
      return Renewal(
        id: id ?? this.id,
        taxiNo: taxiNo ?? this.taxiNo,
        sealing: sealing ?? this.sealing,
        inspection: inspection ?? this.inspection,
        ltefb: ltefb ?? this.ltefb,
        registeration: registeration ?? this.registeration,
        drivingLicense: drivingLicense ?? this.drivingLicense,
        lto: lto ?? this.lto,
        createdAtUtc: createdAtUtc ?? this.createdAtUtc,
        contractStartUtc: contractStartUtc ?? this.contractStartUtc,
        contractEndUtc: contractEndUtc ?? this.contractEndUtc,
      );
    }
  final String? id;
  final String taxiNo;
  final RenewalTypeData? sealing;
  final RenewalTypeData? inspection;
  final RenewalTypeData? ltefb;
  final RenewalTypeData? registeration;
  final RenewalTypeData? drivingLicense;
  final RenewalTypeData? lto;
  final int createdAtUtc;
  final int? contractStartUtc;
  final int? contractEndUtc;

  Renewal({
    this.id,
    required this.taxiNo,
    this.sealing,
    this.inspection,
    this.ltefb,
    this.registeration,
    this.drivingLicense,
    this.lto,
    required this.createdAtUtc,
    this.contractStartUtc,
    this.contractEndUtc,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'taxiNo': taxiNo,
    'sealing': sealing?.toMap(),
    'inspection': inspection?.toMap(),
    'ltefb': ltefb?.toMap(),
    'registeration': registeration?.toMap(),
    'drivingLicense': drivingLicense?.toMap(),
    'lto': lto?.toMap(),
    'createdAtUtc': createdAtUtc,
    'contractStartUtc': contractStartUtc,
    'contractEndUtc': contractEndUtc,
  };

  factory Renewal.fromMap(Map<String, dynamic> m) => Renewal(
    id: m['id'] as String?,
    taxiNo: m['taxiNo'] as String,
    sealing: m['sealing'] != null ? RenewalTypeData.fromMap(m['sealing']) : null,
    inspection: m['inspection'] != null ? RenewalTypeData.fromMap(m['inspection']) : null,
    ltefb: m['ltefb'] != null ? RenewalTypeData.fromMap(m['ltefb']) : null,
    registeration: m['registeration'] != null ? RenewalTypeData.fromMap(m['registeration']) : null,
    drivingLicense: m['drivingLicense'] != null ? RenewalTypeData.fromMap(m['drivingLicense']) : null,
    lto: m['lto'] != null ? RenewalTypeData.fromMap(m['lto']) : null,
    createdAtUtc:
        (m['createdAtUtc'] as int?) ?? DateTime.now().toUtc().millisecondsSinceEpoch,
    contractStartUtc: (m['contractStartUtc'] as int?),
    contractEndUtc: (m['contractEndUtc'] as int?),
  );

}