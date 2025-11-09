import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/models/renewal.dart';
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
    final list = <Renewal>[];
    DateTime current = DateTime.fromMillisecondsSinceEpoch(
      contractStartUtc,
      isUtc: true,
    );
    DateTime next = _addMonths(current, periodMonths);

    if (contractEndUtc == null) {
      final r = Renewal(
        taxiNo: taxiNo,
        label: 'Auto-generated',
        dateUtc: next.toUtc().millisecondsSinceEpoch,
        periodMonths: periodMonths,
        feesCents: feesCents,
        createdAtUtc: DateTime.now().toUtc().millisecondsSinceEpoch,
        contractStartUtc: contractStartUtc,
        contractEndUtc: null,
      );
      list.add(r);
    } else {
      final end = DateTime.fromMillisecondsSinceEpoch(
        contractEndUtc,
        isUtc: true,
      );
      while (!next.isAfter(end)) {
        list.add(
          Renewal(
            taxiNo: taxiNo,
            label: 'Auto-generated',
            dateUtc: next.toUtc().millisecondsSinceEpoch,
            periodMonths: periodMonths,
            feesCents: feesCents,
            createdAtUtc: DateTime.now().toUtc().millisecondsSinceEpoch,
            contractStartUtc: contractStartUtc,
            contractEndUtc: contractEndUtc,
          ),
        );
        next = _addMonths(next, periodMonths);
      }
    }

    emit(RenewalLoaded(renewals: list));
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

  /// Update fees for a draft renewal at [index]
  void updateFees(int index, int feesCents) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final list = List<Renewal>.from(current.renewals);
    final old = list[index];
    list[index] = Renewal(
      id: old.id,
      taxiNo: old.taxiNo,
      label: old.label,
      dateUtc: old.dateUtc,
      periodMonths: old.periodMonths,
      feesCents: feesCents,
      createdAtUtc: old.createdAtUtc,
      contractStartUtc: old.contractStartUtc,
      contractEndUtc: old.contractEndUtc,
    );
    emit(RenewalLoaded(renewals: list));
  }

  /// Update date for a draft renewal at [index]
  void updateDate(int index, int dateUtc) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final list = List<Renewal>.from(current.renewals);
    final old = list[index];
    list[index] = Renewal(
      id: old.id,
      taxiNo: old.taxiNo,
      label: old.label,
      dateUtc: dateUtc,
      periodMonths: old.periodMonths,
      feesCents: old.feesCents,
      createdAtUtc: old.createdAtUtc,
      contractStartUtc: old.contractStartUtc,
      contractEndUtc: old.contractEndUtc,
    );
    emit(RenewalLoaded(renewals: list));
  }

  /// Update periodMonths for a draft renewal at [index]
  void updatePeriod(int index, int periodMonths) {
    final current = state;
    if (current is! RenewalLoaded) return;
    final list = List<Renewal>.from(current.renewals);
    final old = list[index];
    list[index] = Renewal(
      id: old.id,
      taxiNo: old.taxiNo,
      label: old.label,
      dateUtc: old.dateUtc,
      periodMonths: periodMonths,
      feesCents: old.feesCents,
      createdAtUtc: old.createdAtUtc,
      contractStartUtc: old.contractStartUtc,
      contractEndUtc: old.contractEndUtc,
    );
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
