// ignore_for_file: unused_import

import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/common/tab_button.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:action_inc_taxi_app/cubit/car_detail_cubit.dart';
import 'package:action_inc_taxi_app/features/entry_section/renewal/renewal_dates_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/cubit/rent/daily_rent_cubit.dart';
import 'package:action_inc_taxi_app/core/models/rent.dart';
import 'package:action_inc_taxi_app/core/models/driver.dart';
import 'package:intl/intl.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_text_form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_dropdown.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';

class DailyRentCollectionInfoScreen extends StatefulWidget {
  final String taxiNo;
  const DailyRentCollectionInfoScreen({super.key, required this.taxiNo});

  @override
  State<DailyRentCollectionInfoScreen> createState() =>
      _DailyRentCollectionInfoScreenState();
}

class _DailyRentCollectionInfoScreenState
    extends State<DailyRentCollectionInfoScreen> {
  int selectedTabIndex = 0;

  // Controllers for all fields
  final taxiNoController = TextEditingController();
  final numberPlateController = TextEditingController();
  final fleetNoController = TextEditingController();
  final firstDriverNameController = TextEditingController();
  final firstDriverDobController = TextEditingController();
  final firstDriverCnicController = TextEditingController();
  final secondDriverNameController = TextEditingController();
  final secondDriverDobController = TextEditingController();
  final secondDriverCnicController = TextEditingController();
  final totalRentController = TextEditingController(text: '1000 P');
  final rentAmountController = TextEditingController();
  final dueRentController = TextEditingController();
  final paymentCashController = TextEditingController();
  final paymentGCashController = TextEditingController();
  final gCashRefController = TextEditingController();
  final maintenanceFeesController = TextEditingController();
  final carWashFeesController = TextEditingController();
  final paymentDateController = TextEditingController(text: '15/02/2024');
  final contractStartController = TextEditingController();
  final contractEndController = TextEditingController();
  final contractMonthsController = TextEditingController(); // read-only
  final contractExtraDaysController = TextEditingController(text: '0');

  bool carStatusOnRoad = true;
  bool publicHoliday = false;
  bool birthday = false;
  bool mainCheck = true;
  bool secondCheck = false;

  final List<Map<String, String>> renewalData = const [
    {
      'renewal': 'Sealing',
      'taxi': 'Taxi No. 05, 06, 07',
      'status': 'Repaired',
      'date': '01 June, 2024',
    },
    {
      'renewal': 'LTEFB',
      'taxi': 'Taxi No. 05, 06, 07',
      'status': 'Applied',
      'date': '08 Auguest, 2024',
    },
    {
      'renewal': 'Registration',
      'taxi': 'Taxi No. 05, 06, 07',
      'status': 'On Process',
      'date': '01 July, 2024',
    },
    {
      'renewal': 'Driving Licence',
      'taxi': 'Taxi No. 05, 06, 07',
      'status': 'On Process',
      'date': '01 July, 2024',
    },
    {
      'renewal': 'LTO',
      'taxi': 'Taxi No. 05, 06, 07',
      'status': 'On Process',
      'date': '01 July, 2024',
    },
    {
      'renewal': 'Car Insurance',
      'taxi': 'Taxi No. 05, 06, 07',
      'status': 'On Process',
      'date': '01 July, 2024',
    },
  ];

  final List<Map<String, dynamic>> renewalRows = [
    {
      'label': 'LTEFB Renewal',
      'dateController': TextEditingController(text: '15/02/2024'),
      'periodController': TextEditingController(text: 'After 6 months'),
      'feesController': TextEditingController(text: '5000 P'),
    },
    {
      'label': 'Resealing',
      'dateController': TextEditingController(text: '15/02/2024'),
      'periodController': TextEditingController(text: 'After 6 months'),
      'feesController': TextEditingController(text: '5000 P'),
    },
    // Add more rows as needed...
  ];
  late final DailyRentCubit _cubit = DailyRentCubit(DbService());

  int _centsFromController(TextEditingController c) {
    try {
      final raw = c.text.replaceAll(RegExp(r'[^0-9\.]'), '');
      if (raw.isEmpty) return 0;
      final d = double.parse(raw);
      return (d * 100).round();
    } catch (e) {
      return 0;
    }
  }

  void _updateDraftFromControllers() {
    final rentCents = _centsFromController(rentAmountController);
    final maintenanceCents = _centsFromController(maintenanceFeesController);
    final carWashCents = _centsFromController(carWashFeesController);
    final paymentCashCents = _centsFromController(paymentCashController);
    final paymentGCashCents = _centsFromController(paymentGCashController);

    final dateUtc = DateTime.now().toUtc().millisecondsSinceEpoch;

    // parse contract dates and compute months
    final int? contractStartUtc = _parseDateToUtcMs(
      contractStartController.text.trim(),
    );
    final int? contractEndUtc = _parseDateToUtcMs(
      contractEndController.text.trim(),
    );
    final months = Rent.computeMonthsCountFromTimestamps(
      contractStartUtc,
      contractEndUtc,
    );
    final extraDays =
        int.tryParse(contractExtraDaysController.text.trim()) ?? 0;

    final rent = Rent(
      taxiNo: taxiNoController.text.isNotEmpty
          ? taxiNoController.text
          : widget.taxiNo,
      dateUtc: dateUtc,
      contractStartUtc: contractStartUtc,
      contractEndUtc: contractEndUtc,
      monthsCount: months,
      extraDays: extraDays,
      rentAmountCents: rentCents,
      maintenanceFeesCents: maintenanceCents,
      carWashFeesCents: carWashCents,
      paymentCashCents: paymentCashCents,
      paymentGCashCents: paymentGCashCents,
      gCashRef: gCashRefController.text.isNotEmpty
          ? gCashRefController.text
          : null,
      isPublicHoliday: publicHoliday,
      isBirthday: birthday,
      createdAtUtc: DateTime.now().toUtc().millisecondsSinceEpoch,
    );

    // build driver draft if available
    int? dobUtc;
    try {
      // try common formats
      if (firstDriverCnicController.text.trim().isNotEmpty) {
        try {
          dobUtc = DateTime.parse(
            firstDriverDobController.text,
          ).toUtc().millisecondsSinceEpoch;
        } catch (_) {
          try {
            final df = DateFormat('dd/MM/yyyy');
            dobUtc = df
                .parse(firstDriverDobController.text)
                .toUtc()
                .millisecondsSinceEpoch;
          } catch (_) {
            try {
              final df2 = DateFormat('dd MMM, yyyy');
              dobUtc = df2
                  .parse(firstDriverDobController.text)
                  .toUtc()
                  .millisecondsSinceEpoch;
            } catch (_) {
              dobUtc = null;
            }
          }
        }
      }
    } catch (_) {
      dobUtc = null;
    }

    final driver = Driver(
      id: '',
      name: firstDriverNameController.text.trim(),
      dobUtc: dobUtc,
      idCardNo: firstDriverCnicController.text.trim().isEmpty
          ? null
          : firstDriverCnicController.text.trim(),
      createdAtUtc: DateTime.now().toUtc().millisecondsSinceEpoch,
    );

    // collect validation errors: rent.validate() + required CNIC
    final errors = <String, String>{};
    errors.addAll(rent.validate());
    if (driver.idCardNo == null || driver.idCardNo!.isEmpty) {
      errors['driverCnic'] = 'Driver CNIC is required.';
    }

    // Additional required-field checks
    if (taxiNoController.text.trim().isEmpty)
      errors['taxiNo'] = 'Taxi number is required.';
    if (numberPlateController.text.trim().isEmpty)
      errors['numberPlate'] = 'Number plate is required.';
    if (fleetNoController.text.trim().isEmpty)
      errors['fleetNo'] = 'Fleet number is required.';
    if (firstDriverNameController.text.trim().isEmpty)
      errors['firstDriverName'] = 'Driver name is required.';
    if (firstDriverDobController.text.trim().isEmpty)
      errors['firstDriverDob'] = 'Driver DOB is required.';
    if (rentAmountController.text.trim().isEmpty)
      errors['rentAmount'] = 'Rent amount is required.';
    if (paymentDateController.text.trim().isEmpty)
      errors['paymentDate'] = 'Payment date is required.';
    // at least one payment method must have non-zero amount
    if (paymentCashCents + paymentGCashCents <= 0)
      errors['payments'] = 'At least one payment required.';

    _cubit.updateDraft(driver: driver, rent: rent, fieldErrors: errors);

    // update computed fields in UI
    final total = rent.totalCents;
    final due = rent.dueRentCents;
    totalRentController.text = (total / 100).toString();
    dueRentController.text = (due / 100).toString();
    // update months display if contract dates provided
    try {
      int? startUtc;
      int? endUtc;
      if (contractStartController.text.trim().isNotEmpty) {
        startUtc = _parseDateToUtcMs(contractStartController.text.trim());
      }
      if (contractEndController.text.trim().isNotEmpty) {
        endUtc = _parseDateToUtcMs(contractEndController.text.trim());
      }
      final months = Rent.computeMonthsCountFromTimestamps(startUtc, endUtc);
      contractMonthsController.text = months.toString();
    } catch (_) {}
  }

  @override
  void dispose() {
    // persist draft when leaving the screen
    _cubit.saveDraft();
    _cubit.close();
    taxiNoController.dispose();
    numberPlateController.dispose();
    fleetNoController.dispose();
    firstDriverNameController.dispose();
    firstDriverCnicController.dispose();
    firstDriverDobController.dispose();
    secondDriverNameController.dispose();
    secondDriverDobController.dispose();
    totalRentController.dispose();
    rentAmountController.dispose();
    dueRentController.dispose();
    paymentCashController.dispose();
    paymentGCashController.dispose();
    gCashRefController.dispose();
    maintenanceFeesController.dispose();
    carWashFeesController.dispose();
    paymentDateController.dispose();
    contractStartController.dispose();
    contractEndController.dispose();
    contractMonthsController.dispose();
    contractExtraDaysController.dispose();
    super.dispose();
  }

  int? _parseDateToUtcMs(String input) {
    try {
      if (input.trim().isEmpty) return null;
      try {
        return DateTime.parse(input).toUtc().millisecondsSinceEpoch;
      } catch (_) {
        try {
          final df = DateFormat('dd/MM/yyyy');
          return df.parse(input).toUtc().millisecondsSinceEpoch;
        } catch (_) {
          try {
            final df2 = DateFormat('dd MMM, yyyy');
            return df2.parse(input).toUtc().millisecondsSinceEpoch;
          } catch (_) {
            return null;
          }
        }
      }
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _pickDateForController(
    TextEditingController controller, {
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final init = initial ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = _formatDate(picked);
      _updateDraftFromControllers();
    }
  }

  @override
  void initState() {
    super.initState();
    taxiNoController.text = widget.taxiNo;
    _cubit.initWithTaxiNo(widget.taxiNo);
    // default date values: today for date fields, contract end = 2 years from today
    final today = DateTime.now();
    contractStartController.text = _formatDate(today);
    final twoYears = DateTime(today.year + 2, today.month, today.day);
    contractEndController.text = _formatDate(twoYears);
    paymentDateController.text = _formatDate(today);
    firstDriverDobController.text = _formatDate(today);
    secondDriverDobController.text = _formatDate(today);
    // update draft with defaults
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateDraftFromControllers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900.w),
          child: BlocBuilder<DailyRentCubit, DailyRentState>(
            bloc: _cubit,
            builder: (context, state) {
              final fieldErrors = state is DailyRentLoaded
                  ? state.fieldErrors
                  : <String, String>{};
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Car Info',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Car Status:',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 16.w),
                          Checkbox(
                            value: !carStatusOnRoad,
                            onChanged: (v) =>
                                setState(() => carStatusOnRoad = !v!),
                            activeColor: Colors.greenAccent,
                          ),
                          Text(
                            'Off Road',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8.w),
                          Checkbox(
                            value: carStatusOnRoad,
                            onChanged: (v) =>
                                setState(() => carStatusOnRoad = v ?? false),
                            activeColor: Colors.greenAccent,
                          ),
                          Text(
                            'On Road',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWide = constraints.maxWidth > 800;
                      return isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: taxiNoController,
                                        labelText: 'Taxi No',
                                        hintText: 'Enter Taxi No',
                                        errorText: fieldErrors['taxiNo'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: firstDriverNameController,
                                        labelText: 'First Driver Name',
                                        hintText: 'Enter Driver Name',
                                        errorText:
                                            fieldErrors['firstDriverName'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: secondDriverNameController,
                                        labelText: 'Second Driver',
                                        hintText: 'Enter Second Driver',
                                        errorText:
                                            fieldErrors['secondDriverName'],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: numberPlateController,
                                        labelText: 'Number Plate',
                                        hintText: 'Enter Number Plate',
                                        errorText: fieldErrors['numberPlate'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: firstDriverDobController,
                                        labelText: 'First Driver DOB',
                                        hintText: 'DD MMM, YYYY',
                                        isReadOnly: true,
                                        onTap: () => _pickDateForController(
                                          firstDriverDobController,
                                        ),
                                        errorText:
                                            fieldErrors['firstDriverDob'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: secondDriverDobController,
                                        labelText: 'Second Driver DOB',
                                        hintText: 'DD MMM, YYYY',
                                        isReadOnly: true,
                                        onTap: () => _pickDateForController(
                                          secondDriverDobController,
                                        ),
                                        errorText:
                                            fieldErrors['secondDriverDob'],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: fleetNoController,
                                        labelText: 'Fleet No',
                                        hintText: 'Enter Fleet No',
                                        errorText: fieldErrors['fleetNo'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: firstDriverCnicController,
                                        labelText: 'FirstDriver CNIC',
                                        hintText: 'Enter Driver CNIC',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['driverCnic'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: secondDriverCnicController,
                                        labelText: 'Second Driver CNIC',
                                        hintText: 'Enter Driver CNIC',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['driverCnic'],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: taxiNoController,
                                        labelText: 'Taxi No',
                                        hintText: 'Enter Taxi No',
                                        errorText: fieldErrors['taxiNo'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: numberPlateController,
                                        labelText: 'Number Plate',
                                        hintText: 'Enter Number Plate',
                                        errorText: fieldErrors['numberPlate'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: fleetNoController,
                                        labelText: 'Fleet No',
                                        hintText: 'Enter Fleet No',
                                        errorText: fieldErrors['fleetNo'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Checkbox(
                                      value: mainCheck,
                                      onChanged: (v) => setState(
                                        () => mainCheck = v ?? false,
                                      ),
                                      activeColor: Colors.greenAccent,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: firstDriverNameController,
                                        labelText: 'Driver Name',
                                        hintText: 'Enter Driver Name',
                                        errorText:
                                            fieldErrors['firstDriverName'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: firstDriverDobController,
                                        labelText: 'Date of Birth',
                                        hintText: 'DD MMM, YYYY',
                                        isReadOnly: true,
                                        onTap: () => _pickDateForController(
                                          firstDriverDobController,
                                        ),
                                        errorText:
                                            fieldErrors['firstDriverDob'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    SizedBox(width: 48.w),
                                    SizedBox(width: 16.w),
                                    SizedBox(width: 24.w),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: firstDriverCnicController,
                                  labelText: 'Driver CNIC',
                                  hintText: 'Enter Driver CNIC',
                                  onChanged: (s) =>
                                      _updateDraftFromControllers(),
                                  errorText: fieldErrors['driverCnic'],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: secondDriverNameController,
                                        labelText: 'Second Driver',
                                        hintText: 'Enter Second Driver',
                                        errorText:
                                            fieldErrors['secondDriverName'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: secondDriverDobController,
                                        labelText: 'Second Driver DOB',
                                        hintText: 'DD MMM, YYYY',
                                        isReadOnly: true,
                                        onTap: () => _pickDateForController(
                                          secondDriverDobController,
                                        ),
                                        errorText:
                                            fieldErrors['secondDriverDob'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    SizedBox(width: 48.w),
                                    SizedBox(width: 16.w),
                                    Checkbox(
                                      value: secondCheck,
                                      onChanged: (v) => setState(
                                        () => secondCheck = v ?? false,
                                      ),
                                      activeColor: Colors.greenAccent,
                                    ),
                                  ],
                                ),
                              ],
                            );
                    },
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Checkbox(
                        value: publicHoliday,
                        onChanged: (v) => setState(() {
                          publicHoliday = v ?? false;
                          if (publicHoliday) {
                            // apply half-rent rule: take current rent and halve it
                            final cents = _centsFromController(
                              rentAmountController,
                            );
                            final half = (cents / 2).round();
                            rentAmountController.text = (half / 100).toString();
                          }
                          _updateDraftFromControllers();
                        }),
                        activeColor: Colors.greenAccent,
                      ),
                      Text(
                        'Public Holiday(Half Rent)',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 24.w),
                      Checkbox(
                        value: birthday,
                        onChanged: (v) => setState(() {
                          birthday = v ?? false;
                          if (birthday) {
                            rentAmountController.text = '0';
                          }
                          _updateDraftFromControllers();
                        }),
                        activeColor: Colors.greenAccent,
                      ),
                      Text(
                        'Birthday(Zero Rent)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Daily Rent Collection Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  SizedBox(height: 12.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWide = constraints.maxWidth > 800;
                      return isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Contract fields moved here: start, end, extra days, months (computed)
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: contractStartController,
                                        labelText: 'Contract Start',
                                        hintText: 'DD/MM/YYYY',
                                        suffix: Icon(
                                          Icons.calendar_today,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                        isReadOnly: true,
                                        onTap: () => _pickDateForController(
                                          contractStartController,
                                        ),
                                        errorText: fieldErrors['contractStart'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: contractEndController,
                                        labelText: 'Contract End',
                                        hintText: 'DD/MM/YYYY',
                                        suffix: Icon(
                                          Icons.calendar_today,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                        isReadOnly: true,
                                        onTap: () => _pickDateForController(
                                          contractEndController,
                                        ),
                                        errorText: fieldErrors['contractEnd'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: contractExtraDaysController,
                                        labelText: 'Extra Days',
                                        hintText: '0',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['extraDays'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: contractMonthsController,
                                        labelText: 'No. of Months (auto)',
                                        hintText: '0',
                                        isReadOnly: true,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),

                                // Fees column first: Rent, Maintenance, Car Wash
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: rentAmountController,
                                        labelText: 'Rent Amount',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) {
                                          if (birthday) {
                                            rentAmountController.text = '0';
                                            return;
                                          }
                                          if (publicHoliday) {
                                            final cents = _centsFromController(
                                              TextEditingController(text: s),
                                            );
                                            final half = (cents / 2).round();
                                            rentAmountController.text =
                                                (half / 100).toString();
                                          }
                                          _updateDraftFromControllers();
                                        },
                                        errorText: fieldErrors['rentAmount'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: maintenanceFeesController,
                                        labelText: 'Maintenance Fees',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText:
                                            fieldErrors['maintenanceFees'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: carWashFeesController,
                                        labelText: 'Car Wash Fees',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['carWashFees'],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // Payments column: Cash, G-Cash, G-Cash Ref, Payment Date
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: paymentCashController,
                                        labelText: 'Payment in Cash',
                                        hintText: 'Enter Amount',
                                        suffix: Icon(
                                          Icons.money,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['paymentCash'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: paymentGCashController,
                                        labelText: 'Payment in G-Cash',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['paymentGCash'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: gCashRefController,
                                        labelText: 'G-Cash Ref. No',
                                        hintText: 'Enter Ref',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['gCashRef'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: paymentDateController,
                                        labelText: 'Payment Date',
                                        hintText: 'DD/MM/YYYY',
                                        suffix: Icon(
                                          Icons.calendar_today,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                        isReadOnly: true,
                                        onTap: () => _pickDateForController(
                                          paymentDateController,
                                        ),
                                        errorText: fieldErrors['paymentDate'],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // Computed column: Total and Due
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: totalRentController,
                                        labelText: 'Total Rent (computed)',
                                        hintText: 'Total',
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: dueRentController,
                                        labelText: 'Due Rent (computed)',
                                        hintText: 'Due',
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                AppDropdown<String>(
                                  labelText: 'Rent Type',
                                  items: [
                                    const DropdownMenuItem(
                                      value: '',
                                      child: Text(
                                        'Select Type',
                                        style: TextStyle(color: Colors.white54),
                                      ),
                                    ),
                                  ],
                                  onChanged: (v) {},
                                ),
                                SizedBox(height: 12.h),
                                // Fees first (stacked)
                                AppTextFormField(
                                  controller: rentAmountController,
                                  labelText: 'Rent Amount',
                                  hintText: 'Enter Amount',
                                  onChanged: (s) {
                                    if (birthday) {
                                      rentAmountController.text = '0';
                                      return;
                                    }
                                    if (publicHoliday) {
                                      final cents = _centsFromController(
                                        TextEditingController(text: s),
                                      );
                                      final half = (cents / 2).round();
                                      rentAmountController.text = (half / 100)
                                          .toString();
                                    }
                                    _updateDraftFromControllers();
                                  },
                                  errorText: fieldErrors['rentAmount'],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: maintenanceFeesController,
                                        labelText: 'Maintenance Fees',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText:
                                            fieldErrors['maintenanceFees'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: carWashFeesController,
                                        labelText: 'Car Wash Fees',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['carWashFees'],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                // Payments next
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: paymentCashController,
                                        labelText: 'Payment in Cash',
                                        hintText: 'Enter Amount',
                                        suffix: Icon(
                                          Icons.money,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['paymentCash'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: paymentGCashController,
                                        labelText: 'Payment in G-Cash',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['paymentGCash'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: gCashRefController,
                                        labelText: 'G-Cash Ref. No',
                                        hintText: 'Enter Ref',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['gCashRef'],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                // Computed and date row
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: paymentDateController,
                                        labelText: 'Payment Date',
                                        hintText: 'DD/MM/YYYY',
                                        suffix: Icon(
                                          Icons.calendar_today,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                        isReadOnly: true,
                                        onTap: () => _pickDateForController(
                                          paymentDateController,
                                        ),
                                        errorText: fieldErrors['paymentDate'],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: totalRentController,
                                        labelText: 'Total Rent (computed)',
                                        hintText: 'Total',
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: dueRentController,
                                        labelText: 'Due Rent (computed)',
                                        hintText: 'Due',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                    },
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // AppOutlineButton(
                      //   label: 'Cancel',
                      //   onPressed: () {},
                      //   fontSize: 8,
                      // ),
                      // SizedBox(width: 8.w),
                      AppButton(
                        text: 'Next',
                        onPressed: () async {
                          _updateDraftFromControllers();
                          // persist the draft so returning later restores values
                          await _cubit.saveDraft();
                          if (context.mounted) {
                            context.read<CarDetailCubit>().selectTab(1);
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
                  SizedBox(height: 32.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
