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
import 'package:action_inc_taxi_app/core/models/renewal_type_data.dart';
import 'package:action_inc_taxi_app/core/models/enums.dart';

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
  final Map<String, TextEditingController> _feesControllers = {};
  final Map<String, TextEditingController> _dateControllers = {};

  @override
  void initState() {
    super.initState();
    widget.contractStartController?.addListener(_onContractChanged);
    widget.contractEndController?.addListener(_onContractChanged);
    _init();
  }

  void _init() async {
    await _cubit.loadByTaxi(widget.taxiNo);
    final cur = _cubit.state;
    if (cur is RenewalError) {
      final todayUtc = DateTime.now().toUtc().millisecondsSinceEpoch;
      final renewal = Renewal(
        taxiNo: widget.taxiNo,
        sealing: RenewalTypeData(
          dateUtc: todayUtc,
          periodMonths: 6,
          feesCents: 2500,
          status: RenewalStatus.complete,
        ),
        inspection: RenewalTypeData(
          dateUtc: todayUtc,
          periodMonths: 12,
          feesCents: 3000,
          status: RenewalStatus.inProgress,
        ),
        ltefb: RenewalTypeData(
          dateUtc: todayUtc,
          periodMonths: 6,
          feesCents: 5000,
          status: RenewalStatus.applied,
        ),
        registeration: RenewalTypeData(
          dateUtc: todayUtc,
          periodMonths: 24,
          feesCents: 10000,
          status: RenewalStatus.inProgress,
        ),
        drivingLicense: RenewalTypeData(
          dateUtc: todayUtc,
          periodMonths: 12,
          feesCents: 0,
          status: RenewalStatus.inProgress,
        ),
        lto: RenewalTypeData(
          dateUtc: todayUtc,
          periodMonths: 12,
          feesCents: 7500,
          status: RenewalStatus.inProgress,
        ),
        createdAtUtc: DateTime.now().toUtc().millisecondsSinceEpoch,
      );
      _cubit.setDraft(renewal);
    }
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
        feesCents: 1000,
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
        if (state is! RenewalLoaded) {
          // Show loading indicator while renewal is loading
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final renewal = state.renewal;

        // Map of field keys to display names
        const fieldDisplayNames = {
          'sealing': 'Sealing',
          'inspection': 'Inspection',
          'ltefb': 'LTEFB Renewal',
          'registeration': 'Franchise Renewal',
          'drivingLicense': 'Driving Licence',
          'lto': 'LTO Renewal',
        };

        // Map of field keys to RenewalTypeData
        final Map<String, RenewalTypeData?> renewalFields = {
          'sealing': renewal.sealing,
          'inspection': renewal.inspection,
          'ltefb': renewal.ltefb,
          'registeration': renewal.registeration,
          'drivingLicense': renewal.drivingLicense,
          'lto': renewal.lto,
        };

        // Ensure controllers
        renewalFields.forEach((key, data) {
          _feesControllers.putIfAbsent(
            key,
            () => TextEditingController(
              text: data?.feesCents != null
                  ? (data!.feesCents! / 100).toString()
                  : '',
            ),
          );
          _dateControllers.putIfAbsent(key, () {
            if (data?.dateUtc != null) {
              final d = DateTime.fromMillisecondsSinceEpoch(
                data!.dateUtc!,
                isUtc: true,
              ).toLocal();
              return TextEditingController(
                text:
                    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}',
              );
            } else {
              return TextEditingController(text: '');
            }
          });
        });

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
            ...renewalFields.entries.map((entry) {
              final key = entry.key;
              final data = entry.value;
              return _RenewalDataRowWidget(
                fieldKey: key,
                displayName: fieldDisplayNames[key] ?? key,
                data: data,
                isWide: isWide,
                dateController: _dateControllers[key]!,
                feesController: _feesControllers[key]!,
                onFeesChanged: (s) {
                  final cents = int.tryParse(s.replaceAll(',', ''));
                  if (cents != null) {
                    _cubit.updateFees(key, cents * 100);
                  }
                },
                onDateChanged: (utcMs) {
                  _cubit.updateDate(key, utcMs);
                },
                onPeriodChanged: (period) {
                  _cubit.updatePeriod(key, period);
                },
                onStatusChanged: (status) {
                  _cubit.updateStatus(key, status);
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
                    for (final key in renewalFields.keys) {
                      final feesText = _feesControllers[key]!.text.trim();
                      if (feesText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fees.'),
                          ),
                        );
                        return;
                      }
                    }
                    await _cubit.saveDraft();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Renewals saved.')),
                    );
                    // Navigate to renewal_n_status screen after successful save
                    if (mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/renewal_n_status',
                      );
                    }
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
  final String fieldKey;
  final String displayName;
  final RenewalTypeData? data;
  final bool isWide;
  final TextEditingController dateController;
  final TextEditingController feesController;
  final void Function(String) onFeesChanged;
  final void Function(int) onDateChanged;
  final void Function(int) onPeriodChanged;
  final void Function(RenewalStatus) onStatusChanged;

  const _RenewalDataRowWidget({
    required this.fieldKey,
    required this.displayName,
    required this.data,
    required this.isWide,
    required this.dateController,
    required this.feesController,
    required this.onFeesChanged,
    required this.onDateChanged,
    required this.onPeriodChanged,
    required this.onStatusChanged,
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
              labelText: displayName,
              suffix: Icon(Icons.calendar_today, size: 16, color: Colors.white),
              controller: dateController,
              onTap: () async {
                final initial = data?.dateUtc != null
                    ? DateTime.fromMillisecondsSinceEpoch(
                        data!.dateUtc!,
                        isUtc: true,
                      ).toLocal()
                    : DateTime.now();
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Periodic',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                DropdownButton<int>(
                  menuWidth: 16.w,
                  value: data?.periodMonths ?? 6,
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
          Expanded(
            child: AppTextFormField(
              labelText: 'Fees',
              controller: feesController,
              onChanged: onFeesChanged,
            ),
          ),
          Expanded(
            child: DropdownButton<RenewalStatus>(
              value: data?.status ?? RenewalStatus.inProgress,
              dropdownColor: AppColors.background,
              items: RenewalStatus.values
                  .map(
                    (s) => DropdownMenuItem<RenewalStatus>(
                      value: s,
                      child: Text(s.name[0].toUpperCase() + s.name.substring(1)),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onStatusChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}
