import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/enums.dart';
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
      final renewal = await db.getRenewalByTaxi(taxiNo);
      if (renewal != null) {
        emit(RenewalLoaded(renewal: renewal));
      } else {
        emit(RenewalError('No renewal found for taxi $taxiNo'));
      }
    } catch (e) {
      emit(RenewalError(e.toString()));
    }
  }

  void generateFromContract({
    required String taxiNo,
    required int contractStartUtc,
    int? contractEndUtc,
    int periodMonths = 6,
    int feesCents = 1000 * 100,
  }) {
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
    );
    emit(RenewalLoaded(renewal: renewal));
  }

  /// Set the current renewal (used to set defaults or import)
  void setDraft(Renewal renewal) {
    emit(RenewalLoaded(renewal: renewal));
  }

  Future<void> saveDraft() async {
    final current = state;
    if (current is! RenewalLoaded) return;
    emit(RenewalSaving());
    try {
      await db.saveRenewal(current.renewal);
      emit(RenewalSaved());
    } catch (e) {
      emit(RenewalError(e.toString()));
    }
  }

  /// Update a nested renewal type's fees by field key (e.g., 'lto', 'sealing')
  void updateFees(String fieldKey, int feesCents) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final old = current.renewal;
    RenewalTypeData? updated;
    Renewal newRenewal;
    switch (fieldKey) {
      case 'lto':
        updated = (old.lto ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        newRenewal = old.copyWith(lto: updated);
        break;
      case 'sealing':
        updated = (old.sealing ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        newRenewal = old.copyWith(sealing: updated);
        break;
      case 'inspection':
        updated = (old.inspection ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        newRenewal = old.copyWith(inspection: updated);
        break;
      case 'ltefb':
        updated = (old.ltefb ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        newRenewal = old.copyWith(ltefb: updated);
        break;
      case 'registeration':
        updated = (old.registeration ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        newRenewal = old.copyWith(registeration: updated);
        break;
      case 'drivingLicense':
        updated = (old.drivingLicense ?? RenewalTypeData()).copyWith(feesCents: feesCents);
        newRenewal = old.copyWith(drivingLicense: updated);
        break;
      default:
        return;
    }
    emit(RenewalLoaded(renewal: newRenewal));
  }

  /// Update a nested renewal type's date by field key
  void updateDate(String fieldKey, int dateUtc) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final old = current.renewal;
    RenewalTypeData? updated;
    Renewal newRenewal;
    switch (fieldKey) {
      case 'lto':
        updated = (old.lto ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        newRenewal = old.copyWith(lto: updated);
        break;
      case 'sealing':
        updated = (old.sealing ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        newRenewal = old.copyWith(sealing: updated);
        break;
      case 'inspection':
        updated = (old.inspection ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        newRenewal = old.copyWith(inspection: updated);
        break;
      case 'ltefb':
        updated = (old.ltefb ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        newRenewal = old.copyWith(ltefb: updated);
        break;
      case 'registeration':
        updated = (old.registeration ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        newRenewal = old.copyWith(registeration: updated);
        break;
      case 'drivingLicense':
        updated = (old.drivingLicense ?? RenewalTypeData()).copyWith(dateUtc: dateUtc);
        newRenewal = old.copyWith(drivingLicense: updated);
        break;
      default:
        return;
    }
    emit(RenewalLoaded(renewal: newRenewal));
  }

  /// Update a nested renewal type's period by field key
  void updatePeriod(String fieldKey, int periodMonths) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final old = current.renewal;
    RenewalTypeData? updated;
    Renewal newRenewal;
    switch (fieldKey) {
      case 'lto':
        updated = (old.lto ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        newRenewal = old.copyWith(lto: updated);
        break;
      case 'sealing':
        updated = (old.sealing ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        newRenewal = old.copyWith(sealing: updated);
        break;
      case 'inspection':
        updated = (old.inspection ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        newRenewal = old.copyWith(inspection: updated);
        break;
      case 'ltefb':
        updated = (old.ltefb ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        newRenewal = old.copyWith(ltefb: updated);
        break;
      case 'registeration':
        updated = (old.registeration ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        newRenewal = old.copyWith(registeration: updated);
        break;
      case 'drivingLicense':
        updated = (old.drivingLicense ?? RenewalTypeData()).copyWith(periodMonths: periodMonths);
        newRenewal = old.copyWith(drivingLicense: updated);
        break;
      default:
        return;
    }
    emit(RenewalLoaded(renewal: newRenewal));
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
  Future<void> updateStatus(String key , RenewalStatus status){
    final current = state;
    if (current is! RenewalLoaded) return Future.value();
    final old = current.renewal;
    RenewalTypeData? updated;
    Renewal newRenewal;
    switch (key) {
      case 'lto':
        updated = (old.lto ?? RenewalTypeData()).copyWith(status: status);
        newRenewal = old.copyWith(lto: updated);
        break;
      case 'sealing':
        updated = (old.sealing ?? RenewalTypeData()).copyWith(status: status);
        newRenewal = old.copyWith(sealing: updated);
        break;
      case 'inspection':
        updated = (old.inspection ?? RenewalTypeData()).copyWith(status: status);
        newRenewal = old.copyWith(inspection: updated);
        break;
      case 'ltefb':
        updated = (old.ltefb ?? RenewalTypeData()).copyWith(status: status);
        newRenewal = old.copyWith(ltefb: updated);
        break;
      case 'registeration':
        updated = (old.registeration ?? RenewalTypeData()).copyWith(status: status);
        newRenewal = old.copyWith(registeration: updated);
        break;
      case 'drivingLicense':
        updated = (old.drivingLicense ?? RenewalTypeData()).copyWith(status: status);
        newRenewal = old.copyWith(drivingLicense: updated);
        break;
      default:
        return Future.value();
    }
    emit(RenewalLoaded(renewal: newRenewal));
    return Future.value();
    
  }
}
