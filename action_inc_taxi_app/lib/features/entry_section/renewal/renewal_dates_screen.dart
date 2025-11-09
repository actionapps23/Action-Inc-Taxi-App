import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/cubit/renewal/renewal_cubit.dart';
import 'package:action_inc_taxi_app/core/models/renewal.dart';

class RenewalDataTable extends StatefulWidget {
  final String taxiNo;
  final TextEditingController? contractStartController;
  final TextEditingController? contractEndController;

  const RenewalDataTable({
    super.key,
    required this.taxiNo,
    this.contractStartController,
    this.contractEndController,
  });

  @override
  State<RenewalDataTable> createState() => _RenewalDataTableState();
}

class _RenewalDataTableState extends State<RenewalDataTable> {
  late final RenewalCubit _cubit = RenewalCubit(DbService());
  final Map<int, TextEditingController> _feesControllers = {};
  final Map<int, TextEditingController> _dateControllers = {};

  @override
  void initState() {
    super.initState();
    // if contract controllers provided, listen and auto-generate
    widget.contractStartController?.addListener(_onContractChanged);
    widget.contractEndController?.addListener(_onContractChanged);
    // load DB items; if none, populate predefined defaults
    _init();
  }

  void _init() async {
    await _cubit.loadByTaxi(widget.taxiNo);
    final cur = _cubit.state;
    if (cur is RenewalLoaded && cur.renewals.isEmpty) {
      // populate predefined defaults (use contract start when available to compute dates)
      final startUtc = widget.contractStartController == null
          ? null
          : _parseDateToUtcMs(widget.contractStartController!.text.trim());

      DateTime _addMonthsLocal(DateTime from, int months) {
        final y = from.year + ((from.month - 1 + months) ~/ 12);
        final m = ((from.month - 1 + months) % 12) + 1;
        final d = from.day;
        final lastDayOfTarget = DateTime(y, m + 1, 0).day;
        final day = d <= lastDayOfTarget ? d : lastDayOfTarget;
        return DateTime.utc(y, m, day, from.hour, from.minute, from.second);
      }

      DateTime _fallback(DateTime dt) => dt; // identity for readability

      final now = DateTime.now().toUtc();
      final defaultsSpec = [
        {'label': 'LTEFB Renewal', 'period': 6, 'fees': 5000},
        {'label': 'Resealing', 'period': 12, 'fees': 3000},
        {'label': 'Sealing', 'period': 6, 'fees': 2500},
        {'label': 'Franchise Renewal', 'period': 24, 'fees': 10000},
        {'label': 'LTO Renewal', 'period': 12, 'fees': 7500},
        {'label': 'Car Insurance', 'period': 12, 'fees': 15000},
      ];

      final defaults = <Renewal>[];
      for (final spec in defaultsSpec) {
        final period = spec['period'] as int;
        final fees = spec['fees'] as int;
        int dateUtc;
        if (startUtc != null) {
          final startDt = DateTime.fromMillisecondsSinceEpoch(
            startUtc,
            isUtc: true,
          );
          final computed = _addMonthsLocal(startDt, period);
          dateUtc = computed.toUtc().millisecondsSinceEpoch;
        } else {
          // fallback fixed dates (approximate) relative to now if no contract start provided
          final fallbackDate = _fallback(
            DateTime.utc(now.year, now.month, now.day),
          ).add(Duration(days: 30 * period));
          dateUtc = fallbackDate.millisecondsSinceEpoch;
        }
        defaults.add(
          Renewal(
            taxiNo: widget.taxiNo,
            label: spec['label'] as String,
            dateUtc: dateUtc,
            periodMonths: period,
            feesCents: fees * 100,
            createdAtUtc: DateTime.now().toUtc().millisecondsSinceEpoch,
          ),
        );
      }

      _cubit.setDrafts(defaults);
    }
    // also trigger generation if contract start present (only if DB empty would have been replaced above)
    _onContractChanged();
  }

  void _onContractChanged() {
    final startText = widget.contractStartController?.text.trim() ?? '';
    if (startText.isEmpty) return;
    final startUtc = _parseDateToUtcMs(startText);
    final endText = widget.contractEndController?.text.trim() ?? '';
    final endUtc = endText.isEmpty ? null : _parseDateToUtcMs(endText);
    if (startUtc != null) {
      _cubit.generateFromContract(
        taxiNo: widget.taxiNo,
        contractStartUtc: startUtc,
        contractEndUtc: endUtc,
        periodMonths: 6,
        feesCents: 1000 * 100,
      );
    }
  }

  int? _parseDateToUtcMs(String input) {
    try {
      if (input.trim().isEmpty) return null;
      try {
        return DateTime.parse(input).toUtc().millisecondsSinceEpoch;
      } catch (_) {
        try {
          final parts = input.split('/');
          if (parts.length == 3) {
            final d = int.parse(parts[0]);
            final m = int.parse(parts[1]);
            final y = int.parse(parts[2]);
            return DateTime.utc(y, m, d).millisecondsSinceEpoch;
          }
        } catch (_) {}
      }
    } catch (_) {}
    return null;
  }

  @override
  void dispose() {
    widget.contractStartController?.removeListener(_onContractChanged);
    widget.contractEndController?.removeListener(_onContractChanged);
    for (final c in _feesControllers.values) {
      c.dispose();
    }
    for (final c in _dateControllers.values) {
      c.dispose();
    }
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 800;
    return BlocBuilder<RenewalCubit, RenewalState>(
      bloc: _cubit,
      builder: (context, state) {
        final renewals = state is RenewalLoaded ? state.renewals : <Renewal>[];
        // ensure controllers
        for (var i = 0; i < renewals.length; i++) {
          _feesControllers.putIfAbsent(
            i,
            () => TextEditingController(
              text: (renewals[i].feesCents / 100).toString(),
            ),
          );
          _dateControllers.putIfAbsent(i, () {
            final d = DateTime.fromMillisecondsSinceEpoch(
              renewals[i].dateUtc,
              isUtc: true,
            ).toLocal();
            return TextEditingController(
              text:
                  '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}',
            );
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Renewal Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            ...renewals.asMap().entries.map((entry) {
              final i = entry.key;
              final r = entry.value;
              return _RenewalDataRowWidget(
                index: i,
                renewal: r,
                isWide: isWide,
                dateController: _dateControllers[i]!,
                feesController: _feesControllers[i]!,
                onFeesChanged: (s) {
                  final raw = s.replaceAll(RegExp(r'[^0-9\.]'), '');
                  final d = raw.isEmpty ? 0.0 : double.tryParse(raw) ?? 0.0;
                  final cents = (d * 100).round();
                  _cubit.updateFees(i, cents);
                },
                onDateChanged: (utcMs) {
                  _cubit.updateDate(i, utcMs);
                },
                onPeriodChanged: (period) {
                  _cubit.updatePeriod(i, period);
                },
              );
            }).toList(),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppOutlineButton(
                  label: 'Cancel',
                  onPressed: () {},
                  fontSize: 8,
                ),
                SizedBox(width: 8.w),
                AppButton(
                  text: 'Submit Now',
                  onPressed: () async {
                    // validate all fields required
                    final current = _cubit.state;
                    if (current is! RenewalLoaded) return;
                    for (var i = 0; i < current.renewals.length; i++) {
                      final feesText = _feesControllers[i]!.text.trim();
                      if (feesText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fees.'),
                          ),
                        );
                        return;
                      }
                    }
                    await _cubit.saveAllDrafts();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Renewals saved.')),
                    );
                  },
                  backgroundColor: Colors.green,
                  textColor: AppColors.buttonText,
                  width: 40.w,
                  height: 36.h,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        );
      },
    );
  }
}

class _RenewalDataRowWidget extends StatelessWidget {
  final int index;
  final Renewal renewal;
  final bool isWide;
  final TextEditingController dateController;
  final TextEditingController feesController;
  final void Function(String) onFeesChanged;
  final void Function(int) onDateChanged;
  final void Function(int) onPeriodChanged;

  const _RenewalDataRowWidget({
    required this.index,
    required this.renewal,
    required this.isWide,
    required this.dateController,
    required this.feesController,
    required this.onFeesChanged,
    required this.onDateChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppTextFormField(
              labelText: renewal.label,
              suffix: Icon(Icons.calendar_today, size: 16, color: Colors.white),
              controller: dateController,
              onTap: () async {
                // show date picker and call onDateChanged with new utc ms
                final initial = DateTime.fromMillisecondsSinceEpoch(
                  renewal.dateUtc,
                  isUtc: true,
                ).toLocal();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  dateController.text =
                      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                  onDateChanged(picked.toUtc().millisecondsSinceEpoch);
                }
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Periodic',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DropdownButton<int>(
                  value: renewal.periodMonths,
                  dropdownColor: AppColors.background,
                  items: [1, 3, 6, 7, 12, 24, 36]
                      .map(
                        (m) => DropdownMenuItem<int>(
                          value: m,
                          child: Text('After $m month${m == 1 ? '' : 's'}'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onPeriodChanged(v);
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: AppTextFormField(
              labelText: 'Fees',
              controller: feesController,
              onChanged: onFeesChanged,
            ),
          ),
        ],
      ),
    );
  }
}
