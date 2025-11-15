import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/renewal.dart' show Renewal;
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/cubit/car_detail_cubit.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_and_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/cubit/renewal/renewal_cubit.dart';
import 'package:action_inc_taxi_app/core/models/renewal_type_data.dart';
import 'package:action_inc_taxi_app/cubit/rent/daily_rent_cubit.dart';
import 'package:uuid/uuid.dart';

class RenewalDataTable extends StatefulWidget {
  const RenewalDataTable({super.key});

  @override
  State<RenewalDataTable> createState() => _RenewalDataTableState();
}

class _RenewalDataTableState extends State<RenewalDataTable> {
  late final RenewalCubit _cubit = RenewalCubit(DbService());
  final Map<String, TextEditingController> _feesControllers = {};
  Map<String, RenewalTypeData?> renewalFields = {};

  int? getContractStartUtc() {
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
  void initState() {
    super.initState();
    final contractStartUtc = getContractStartUtc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DateTime contractStart = contractStartUtc != null
          ? DateTime.fromMillisecondsSinceEpoch(contractStartUtc, isUtc: true)
          : DateTime.now().toUtc();
      renewalFields = {
        'sealing': RenewalTypeData(
          dateUtc: HelperFunctions.addMonths(
            contractStart,
            1,
          ).millisecondsSinceEpoch,
          periodMonths: 1,
          feesCents: 100,
        ),
        'inspection': RenewalTypeData(
          dateUtc: HelperFunctions.addMonths(
            contractStart,
            12,
          ).millisecondsSinceEpoch,
          periodMonths: 12,
          feesCents: 100,
        ),
        'ltefb': RenewalTypeData(
          dateUtc: HelperFunctions.addMonths(
            contractStart,
            6,
          ).millisecondsSinceEpoch,
          periodMonths: 6,
          feesCents: 100,
        ),
        'registeration': RenewalTypeData(
          dateUtc: HelperFunctions.addMonths(
            contractStart,
            24,
          ).millisecondsSinceEpoch,
          periodMonths: 24,
          feesCents: 100,
        ),
        'drivingLicense': RenewalTypeData(
          dateUtc: HelperFunctions.addMonths(
            contractStart,
            12,
          ).millisecondsSinceEpoch,
          periodMonths: 12,
          feesCents: 100,
        ),
        'lto': RenewalTypeData(
          dateUtc: HelperFunctions.addMonths(
            contractStart,
            12,
          ).millisecondsSinceEpoch,
          periodMonths: 12,
          feesCents: 100,
        ),
      };
      final selectionCubit = context.read<SelectionCubit>();
      _cubit.update(
        renewal: Renewal(
          taxiNo: selectionCubit.state.taxiNo,
          createdAtUtc: HelperFunctions.currentUtcTimeMilliSeconds(),
          contractStartUtc: contractStartUtc,
          contractEndUtc: null,
          sealing: renewalFields['sealing'],
          inspection: renewalFields['inspection'],
          ltefb: renewalFields['ltefb'],
          registeration: renewalFields['registeration'],
          drivingLicense: renewalFields['drivingLicense'],
          lto: renewalFields['lto'],
          id: Uuid().v4(),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (final c in _feesControllers.values) {
      c.dispose();
    }
    // _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 800;

    return BlocBuilder<RenewalCubit, RenewalState>(
      bloc: _cubit,
      builder: (context, state) {
        const fieldDisplayNames = {
          'sealing': 'Sealing',
          'inspection': 'Inspection',
          'ltefb': 'LTEFB Renewal',
          'registeration': 'Franchise Renewal',
          'drivingLicense': 'Driving Licence',
          'lto': 'LTO Renewal',
        };

        renewalFields.forEach((key, data) {
          _feesControllers.putIfAbsent(
            key,
            () => TextEditingController(
              text: data?.feesCents != null
                  ? (data!.feesCents!).toString()
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
                contractStartUtc: getContractStartUtc(),
                onFeesChanged: (s) {
                  final cents = int.tryParse(s.replaceAll(',', ''));
                  if (cents != null) {
                    _cubit.updateFees(key, cents);
                  }
                },
                onPeriodChanged: (period) {
                  if (key == 'lto') {
                    final newLto = RenewalTypeData(
                      dateUtc: HelperFunctions.addMonths(
                        HelperFunctions.getDateTimeFromUtcMilliSeconds(
                          getContractStartUtc()!,
                        ),
                        period ?? 0,
                      ).millisecondsSinceEpoch,
                      periodMonths: period,
                      feesCents: data?.feesCents,
                    );
                    final newRenewal = (_cubit.state as RenewalLoaded).renewal
                        .copyWith(lto: newLto);
                    _cubit.update(renewal: newRenewal);
                  } else if (key == 'sealing') {
                    final newSealing = RenewalTypeData(
                      dateUtc: HelperFunctions.addMonths(
                        HelperFunctions.getDateTimeFromUtcMilliSeconds(
                          getContractStartUtc()!,
                        ),
                        period ?? 0,
                      ).millisecondsSinceEpoch,
                      periodMonths: period,
                      feesCents: data?.feesCents,
                    );
                    final newRenewal = (_cubit.state as RenewalLoaded).renewal
                        .copyWith(sealing: newSealing);
                    _cubit.update(renewal: newRenewal);
                  } else if (key == 'inspection') {
                    final newInspection = RenewalTypeData(
                      dateUtc: HelperFunctions.addMonths(
                        HelperFunctions.getDateTimeFromUtcMilliSeconds(
                          getContractStartUtc()!,
                        ),
                        period ?? 0,
                      ).millisecondsSinceEpoch,
                      periodMonths: period,
                      feesCents: data?.feesCents,
                    );
                    final newRenewal = (_cubit.state as RenewalLoaded).renewal
                        .copyWith(inspection: newInspection);
                    _cubit.update(renewal: newRenewal);
                  } else if (key == 'ltefb') {
                    final newLtefb = RenewalTypeData(
                      dateUtc: HelperFunctions.addMonths(
                        HelperFunctions.getDateTimeFromUtcMilliSeconds(
                          getContractStartUtc()!,
                        ),
                        period ?? 0,
                      ).millisecondsSinceEpoch,
                      periodMonths: period,
                      feesCents: data?.feesCents,
                    );
                    final newRenewal = (_cubit.state as RenewalLoaded).renewal
                        .copyWith(ltefb: newLtefb);
                    _cubit.update(renewal: newRenewal);
                  } else if (key == 'registeration') {
                    final newRegisteration = RenewalTypeData(
                      dateUtc: HelperFunctions.addMonths(
                        HelperFunctions.getDateTimeFromUtcMilliSeconds(
                          getContractStartUtc()!,
                        ),
                        period ?? 0,
                      ).millisecondsSinceEpoch,
                      periodMonths: period,
                      feesCents: data?.feesCents,
                    );
                    final newRenewal = (_cubit.state as RenewalLoaded).renewal
                        .copyWith(registeration: newRegisteration);
                    _cubit.update(renewal: newRenewal);
                  } else if (key == 'drivingLicense') {
                    final newDrivingLicense = RenewalTypeData(
                      dateUtc: HelperFunctions.addMonths(
                        HelperFunctions.getDateTimeFromUtcMilliSeconds(
                          getContractStartUtc()!,
                        ),
                        period ?? 0,
                      ).millisecondsSinceEpoch,
                      periodMonths: period,
                      feesCents: data?.feesCents,
                    );
                    final newRenewal = (_cubit.state as RenewalLoaded).renewal
                        .copyWith(drivingLicense: newDrivingLicense);
                    _cubit.update(renewal: newRenewal);
                  }
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
                  onPressed: () {
                    context.read<CarDetailCubit>().selectTab(0);
                  },
                  fontSize: 8,
                ),
                SizedBox(width: 8.w),
                AppButton(
                  text: 'Submit Now',
                  onPressed: () async {
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
                    final DailyRentCubit dailyRentCubit = context
                        .read<DailyRentCubit>();
                    try {
                      await dailyRentCubit.saveCarDetailInfo();
                      await _cubit.saveRenewal();
                    } catch (e) {
                      SnackBarHelper.showErrorSnackBar(
                        context,
                        'Error saving data: $e',
                        duration: Duration(seconds: 2),
                      );
                      return;
                    }
                    SnackBarHelper.showSuccessSnackBar(
                      context,
                      'Renewal data saved successfully.',
                      duration: Duration(seconds: 2),
                    );
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
      final baseUtc =
          widget.contractStartUtc ??
          DateTime.now().toUtc().millisecondsSinceEpoch;
      final renewalDate = _calculateRenewalDate(baseUtc, _selectedPeriod);
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
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
                          ...[1, 3, 6, 7, 12, 24, 36].map(
                            (m) => DropdownMenuItem<int?>(
                              value: m,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
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
                          ),
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
