import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_and_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/cubit/renewal/renewal_cubit.dart';
import 'package:action_inc_taxi_app/core/models/renewal.dart';
import 'package:action_inc_taxi_app/core/models/renewal_type_data.dart';
import 'package:action_inc_taxi_app/core/models/enums.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/cubit/rent/daily_rent_cubit.dart';

class RenewalDataTable extends StatefulWidget {
  const RenewalDataTable({super.key});

  @override
  State<RenewalDataTable> createState() => _RenewalDataTableState();
}

class _RenewalDataTableState extends State<RenewalDataTable> {
  late final RenewalCubit _cubit = RenewalCubit(DbService());
  final Map<String, TextEditingController> _feesControllers = {};
  late String _taxiNo;

  @override
  void initState() {
    super.initState();
    _taxiNo = context.read<SelectionCubit>().state.taxiNo;
    _init();
  }

  void _init() async {
    await _cubit.loadByTaxi(_taxiNo);
    final cur = _cubit.state;
    if (cur is RenewalError) {
      final todayUtc = DateTime.now().toUtc().millisecondsSinceEpoch;
      final renewal = Renewal(
        taxiNo: _taxiNo,
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
  }

  int? _getContractStartUtc() {
    try {
      final dailyRentCubit = context.read<DailyRentCubit>();
      if (dailyRentCubit.state is DailyRentLoaded) {
        final state = dailyRentCubit.state as DailyRentLoaded;
        return state.rent?.contractStartUtc;
      }
    } catch (_) {}
    return null;
  }

  @override
  void dispose() {
    for (final c in _feesControllers.values) {
      c.dispose();
    }
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 800;
    final contractStartUtc = _getContractStartUtc();

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

        // Ensure controllers and update dates based on period
        renewalFields.forEach((key, data) {
          _feesControllers.putIfAbsent(
            key,
            () => TextEditingController(
              text: data?.feesCents != null
                  ? (data!.feesCents! / 100).toString()
                  : '',
            ),
          );
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
                feesController: _feesControllers[key]!,
                contractStartUtc: contractStartUtc,
                onFeesChanged: (s) {
                  final cents = int.tryParse(s.replaceAll(',', ''));
                  if (cents != null) {
                    _cubit.updateFees(key, cents * 100);
                  }
                },
                onPeriodChanged: (period) {
                  _cubit.updatePeriod(key, period);
                },
              );
            }),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RenewalAndStatusScreen(),
                        ),
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

class _RenewalDataRowWidget extends StatefulWidget {
  final String fieldKey;
  final String displayName;
  final RenewalTypeData? data;
  final bool isWide;
  final TextEditingController feesController;
  final void Function(String) onFeesChanged;
  final void Function(int?) onPeriodChanged;
  final int? contractStartUtc;

  const _RenewalDataRowWidget({
    required this.fieldKey,
    required this.displayName,
    required this.data,
    required this.isWide,
    required this.feesController,
    required this.onFeesChanged,
    required this.onPeriodChanged,
    required this.contractStartUtc,
  });

  @override
  State<_RenewalDataRowWidget> createState() => _RenewalDataRowWidgetState();
}

class _RenewalDataRowWidgetState extends State<_RenewalDataRowWidget> {
  late int? _selectedPeriod;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.data?.periodMonths;
    dateController = TextEditingController();
    // Schedule update after widget builds so contractStartUtc is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDateDisplay();
    });
  }

  @override
  void didUpdateWidget(_RenewalDataRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data?.periodMonths != widget.data?.periodMonths ||
        oldWidget.contractStartUtc != widget.contractStartUtc) {
      _selectedPeriod = widget.data?.periodMonths;
      _updateDateDisplay();
    }
  }

  void _updateDateDisplay() {
    if (_selectedPeriod == null) {
      dateController.text = '';
    } else {
      // Try to use contractStartUtc, fallback to now if not available
      final baseUtc = widget.contractStartUtc ?? DateTime.now().toUtc().millisecondsSinceEpoch;
      final renewalDate = _calculateRenewalDate(
        baseUtc,
        _selectedPeriod,
      );
      dateController.text = _formatDate(renewalDate);
    }
  }

  DateTime? _calculateRenewalDate(int? contractStartUtc, int? periodMonths) {
    if (contractStartUtc == null || periodMonths == null || periodMonths <= 0) {
      return null;
    }
    final startDate = DateTime.fromMillisecondsSinceEpoch(
      contractStartUtc,
      isUtc: true,
    );
    return DateTime.utc(
      startDate.year,
      startDate.month + periodMonths,
      startDate.day,
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _getPeriodLabel(int? period) {
    if (period == null) return 'None';
    return '$period month${period == 1 ? '' : 's'}';
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: AppTextFormField(
              labelText: widget.displayName,
              suffix: Icon(Icons.calendar_today, size: 16, color: Colors.white),
              controller: dateController,
              isReadOnly: true,
              enabled: false,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Periodic',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black26,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _getPeriodLabel(_selectedPeriod),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DropdownButton<int?>(
                        underline: SizedBox(),
                        value: _selectedPeriod,
                        dropdownColor: Color(0xFF1a1a1a),
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                'None',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          ...[1, 3, 6, 7, 12, 24, 36]
                              .map(
                                (m) => DropdownMenuItem<int?>(
                                  value: m,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text(
                                      '$m month${m == 1 ? '' : 's'}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _selectedPeriod = v;
                            _updateDateDisplay();
                          });
                          widget.onPeriodChanged(v);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: AppTextFormField(
              labelText: 'Fees',
              controller: widget.feesController,
              onChanged: widget.onFeesChanged,
            ),
          ),
        ],
      ),
    );
  }
}
