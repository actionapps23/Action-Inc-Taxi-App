import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/renewal.dart';
import 'package:action_inc_taxi_app/core/models/renewal_type_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'renewal_state.dart';

class RenewalCubit extends Cubit<RenewalState> {
  final DbService db;
  RenewalCubit(this.db) : super(RenewalInitial());

  Future<void> loadByTaxi(String taxiNo) async {
    emit(RenewalLoading());
    try {
      final items = await db.getRenewalsByTaxi(taxiNo);
      emit(RenewalLoaded(renewals: items));
    } catch (e) {
      emit(RenewalError(e.toString()));
    }
  }

  /// Generate recurring renewals starting from contractStartUtc.
  /// If contractEndUtc is provided, generate occurrences where next <= contractEndUtc.
  /// If no contractEndUtc, generate a single next occurrence (start + periodMonths).
  void generateFromContract({
    required String taxiNo,
    required int contractStartUtc,
    int? contractEndUtc,
    int periodMonths = 6,
    int feesCents = 1000 * 100,
  }) {
    // For demonstration, only generate LTO renewal. Expand as needed for other types.
    final ltoData = RenewalTypeData(
      dateUtc: contractEndUtc ?? _addMonths(DateTime.fromMillisecondsSinceEpoch(contractStartUtc, isUtc: true), periodMonths).toUtc().millisecondsSinceEpoch,
      periodMonths: periodMonths,
      feesCents: feesCents,
    );
    final renewal = Renewal(
      taxiNo: taxiNo,
      lto: ltoData,
      createdAtUtc: DateTime.now().toUtc().millisecondsSinceEpoch,
      contractStartUtc: contractStartUtc,
      contractEndUtc: contractEndUtc,
      // Add other types as needed
    );
    emit(RenewalLoaded(renewals: [renewal]));
  }

  /// Replace draft list in cubit (used to set defaults or import)
  void setDrafts(List<Renewal> drafts) {
    emit(RenewalLoaded(renewals: List<Renewal>.from(drafts)));
  }

  Future<void> saveAllDrafts() async {
    final current = state;
    if (current is! RenewalLoaded) return;
    emit(RenewalSaving());
    try {
      await db.saveRenewals(current.renewals);
      emit(RenewalSaved());
    } catch (e) {
      emit(RenewalError(e.toString()));
    }
  }

  /// Update a nested renewal type's fees by field key (e.g., 'lto', 'sealing')
  void updateFees(int index, String fieldKey, int feesCents) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final list = List<Renewal>.from(current.renewals);
    final old = list[index];
    RenewalTypeData? updated;
    switch (fieldKey) {
      case 'lto':
        updated = (old.lto ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        list[index] = old.copyWith(lto: updated);
        break;
      case 'sealing':
        updated = (old.sealing ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        list[index] = old.copyWith(sealing: updated);
        break;
      case 'inspection':
        updated = (old.inspection ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        list[index] = old.copyWith(inspection: updated);
        break;
      case 'ltefb':
        updated = (old.ltefb ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        list[index] = old.copyWith(ltefb: updated);
        break;
      case 'registeration':
        updated = (old.registeration ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        list[index] = old.copyWith(registeration: updated);
        break;
      case 'drivingLicense':
        updated = (old.drivingLicense ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        list[index] = old.copyWith(drivingLicense: updated);
        break;
    }
    emit(RenewalLoaded(renewals: list));
  }

  /// Update a nested renewal type's date by field key
  void updateDate(int index, String fieldKey, int dateUtc) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final list = List<Renewal>.from(current.renewals);
    final old = list[index];
    RenewalTypeData? updated;
    switch (fieldKey) {
      case 'lto':
        updated = (old.lto ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        list[index] = old.copyWith(lto: updated);
        break;
      case 'sealing':
        updated = (old.sealing ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        list[index] = old.copyWith(sealing: updated);
        break;
      case 'inspection':
        updated = (old.inspection ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        list[index] = old.copyWith(inspection: updated);
        break;
      case 'ltefb':
        updated = (old.ltefb ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        list[index] = old.copyWith(ltefb: updated);
        break;
      case 'registeration':
        updated = (old.registeration ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        list[index] = old.copyWith(registeration: updated);
        break;
      case 'drivingLicense':
        updated = (old.drivingLicense ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        list[index] = old.copyWith(drivingLicense: updated);
        break;
    }
    emit(RenewalLoaded(renewals: list));
  }

  /// Update a nested renewal type's period by field key
  void updatePeriod(int index, String fieldKey, int periodMonths) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final list = List<Renewal>.from(current.renewals);
    final old = list[index];
    RenewalTypeData? updated;
    switch (fieldKey) {
      case 'lto':
        updated = (old.lto ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        list[index] = old.copyWith(lto: updated);
        break;
      case 'sealing':
        updated = (old.sealing ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        list[index] = old.copyWith(sealing: updated);
        break;
      case 'inspection':
        updated = (old.inspection ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        list[index] = old.copyWith(inspection: updated);
        break;
      case 'ltefb':
        updated = (old.ltefb ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        list[index] = old.copyWith(ltefb: updated);
        break;
      case 'registeration':
        updated = (old.registeration ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        list[index] = old.copyWith(registeration: updated);
        break;
      case 'drivingLicense':
        updated = (old.drivingLicense ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        list[index] = old.copyWith(drivingLicense: updated);
        break;
    }
    emit(RenewalLoaded(renewals: list));
  }

  // small helper to add months preserving day where possible
  DateTime _addMonths(DateTime from, int months) {
    final y = from.year + ((from.month - 1 + months) ~/ 12);
    final m = ((from.month - 1 + months) % 12) + 1;
    final d = from.day;
    final lastDayOfTarget = DateTime(y, m + 1, 0).day;
    final day = d <= lastDayOfTarget ? d : lastDayOfTarget;
    return DateTime.utc(y, m, day, from.hour, from.minute, from.second);
  }
}
