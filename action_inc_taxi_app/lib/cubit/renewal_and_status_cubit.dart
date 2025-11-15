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
      final displayRows = _mapToDisplayRows(filtered);
      emit(
        RenewalAndStatusLoaded(
          allRows: rows,
          filteredRows: displayRows,
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
        final displayRows = _mapToDisplayRows(filtered);
        emit(
          current.copyWith(filteredRows: displayRows, selectedFilter: index),
        );
      } catch (e) {
        emit(RenewalAndStatusFailure(e.toString()));
      }
    }
  }

  // Map filtered rows to display rows for the DataTable
  List<Map<String, dynamic>> _mapToDisplayRows(
    List<Map<String, dynamic>> filteredRows,
  ) {
    const renewalLabels = {
      'lto': 'LTO',
      'sealing': 'Sealing',
      'inspection': 'Inspection',
      'ltefb': 'LTEFB',
      'registeration': 'Registration',
      'drivingLicense': 'Driving License',
    };
    List<Map<String, dynamic>> displayRows = [];
    for (final row in filteredRows) {
      // If row is already a renewal row (flat), use its keys directly
      final renewalType = row['renewalType'] ?? row['renewal'] ?? '';
      if (row.containsKey('dateUtc')) {
        // Format date
        String dateStr = '';
        final dateRaw = row['dateUtc'];
        if (dateRaw != null) {
          DateTime? d;
          try {
            if (dateRaw is int) {
              d = DateTime.fromMillisecondsSinceEpoch(
                dateRaw,
                isUtc: true,
              ).toLocal();
            } else if (dateRaw is String) {
              final ms = int.tryParse(dateRaw);
              if (ms != null) {
                d = DateTime.fromMillisecondsSinceEpoch(
                  ms,
                  isUtc: true,
                ).toLocal();
              } else if (dateRaw.contains('/')) {
                final parts = dateRaw.split('/');
                if (parts.length >= 3) {
                  final day = int.tryParse(parts[0]) ?? 1;
                  final month = int.tryParse(parts[1]) ?? 1;
                  final year = int.tryParse(parts[2]) ?? DateTime.now().year;
                  d = DateTime(year, month, day);
                }
              } else {
                d = DateTime.tryParse(dateRaw);
              }
            }
          } catch (_) {
            d = null;
          }
          if (d != null) {
            dateStr =
                "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
          }
        }
        displayRows.add({
          'renewal': renewalLabels[renewalType] ?? renewalType,
          'taxi': row['taxiNo'] ?? '',
          'status': row['status'] ?? '',
          'date': dateStr,
        });
      }
    }
    return displayRows;
  }

  List<Map<String, dynamic>> _filterBy(
    List<Map<String, dynamic>> rows,
    int index,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    const renewalKeys = [
      'lto',
      'sealing',
      'inspection',
      'ltefb',
      'registeration',
      'drivingLicense',
    ];
    List<Map<String, dynamic>> result = [];
    for (final r in rows) {
      for (final key in renewalKeys) {
        final renewal = r[key];
        if (renewal is Map<String, dynamic> && renewal['dateUtc'] is int) {
          final d = DateTime.fromMillisecondsSinceEpoch(
            renewal['dateUtc'],
            isUtc: true,
          ).toLocal();
          final dateOnly = DateTime(d.year, d.month, d.day);
          bool match = false;
          switch (index) {
            case 0:
              final weekDay = today.weekday;
              final weekStart = today.subtract(Duration(days: weekDay - 1));
              final weekEnd = weekStart.add(const Duration(days: 6));
              match =
                  !dateOnly.isBefore(weekStart) && !dateOnly.isAfter(weekEnd);
              break;
            case 1:
              match =
                  dateOnly.year == today.year && dateOnly.month == today.month;
              break;
            case 2:
              match = dateOnly.year == today.year;
              print(match);
              break;
            default:
              match = true;
          }
          if (match) {
            result.add({'renewalType': key, 'taxiNo': r['taxiNo'], ...renewal});
          }
        }
      }
    }
    return result;
  }
}
