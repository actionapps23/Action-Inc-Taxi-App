import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/db_service.dart';
import 'renewal_and_status_state.dart';

class RenewalAndStatusCubit extends Cubit<RenewalAndStatusState> {
  final DbService dbService;

  RenewalAndStatusCubit(this.dbService) : super(RenewalAndStatusInitial()) {
    load();
  }

  Future<void> load() async {
    try {
      emit(RenewalAndStatusLoading());
      final rows = await dbService.fetchAllRenewals();
      final filtered = _filterBy(rows, 0);
      emit(
        RenewalAndStatusLoaded(
          allRows: rows,
          filteredRows: filtered,
          selectedFilter: 0,
        ),
      );
    } catch (e) {
      emit(RenewalAndStatusFailure(e.toString()));
    }
  }

  Future<void> filterBy(int index) async {
    final current = state;
    if (current is RenewalAndStatusLoaded) {
      try {
        emit(RenewalAndStatusLoading());
        final filtered = _filterBy(current.allRows, index);
        emit(current.copyWith(filteredRows: filtered, selectedFilter: index));
      } catch (e) {
        emit(RenewalAndStatusFailure(e.toString()));
      }
    }
  }

  List<Map<String, dynamic>> _filterBy(
    List<Map<String, dynamic>> rows,
    int index,
  ) {
    final now = DateTime.now();
    return rows.where((r) {
      final dateStr = (r['date'] ?? '').toString();
      if (dateStr.isEmpty) return false;
      DateTime? d;
      try {
        if (dateStr.contains('/')) {
          final parts = dateStr.split('/');
          if (parts.length >= 3) {
            final day = int.tryParse(parts[0]) ?? 1;
            final month = int.tryParse(parts[1]) ?? 1;
            final year = int.tryParse(parts[2]) ?? now.year;
            d = DateTime(year, month, day);
          }
        } else {
          d = DateTime.parse(dateStr);
        }
      } catch (_) {
        d = null;
      }
      if (d == null) return false;
      switch (index) {
        case 0:
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 7));
          return d.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
              d.isBefore(weekEnd.add(const Duration(seconds: 1)));
        case 1:
          return d.year == now.year && d.month == now.month;
        case 2:
          return d.year == now.year;
        default:
          return true;
      }
    }).toList();
  }
}
