import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/car_info.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/cubit/car_details/car_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/rent/daily_rent_cubit.dart';
import 'package:action_inc_taxi_app/core/models/rent.dart';
import 'package:action_inc_taxi_app/core/models/driver.dart';
import 'package:intl/intl.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_dropdown.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';

class DailyRentCollectionInfoScreen extends StatefulWidget {
  const DailyRentCollectionInfoScreen({super.key});

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
  bool _firstDriverSelected = true;
  bool _secondDriverSelected = false;

  double? _originalRent;
  double? _originalMaintenance;
  double? _originalCarWash;

  late final DailyRentCubit _cubit = context.read<DailyRentCubit>();

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
    // Set default values if empty
    if (carWashFeesController.text.trim().isEmpty) {
      carWashFeesController.text = '75';
    }
    if (maintenanceFeesController.text.trim().isEmpty) {
      maintenanceFeesController.text = '100';
    }
    if (paymentGCashController.text.trim().isEmpty) {
      paymentGCashController.text = '0';
    }
    // Get original rent value
    int rentCents = _centsFromController(rentAmountController);
    final maintenanceCents = _centsFromController(maintenanceFeesController);
    final carWashCents = _centsFromController(carWashFeesController);
    final paymentCashCents = _centsFromController(paymentCashController);
    final paymentGCashCents = _centsFromController(paymentGCashController);

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

    // Business logic for birthday/public holiday
    int computedRentCents = rentCents;
    // No side effect on rentAmountController for birthday/publicHoliday
    // Only total/due are affected at the end
    if (!publicHoliday &&
        _originalRent != null &&
        _originalMaintenance != null &&
        _originalCarWash != null) {
      // restore original values
      rentAmountController.text = (_originalRent!).toString();
      maintenanceFeesController.text = (_originalMaintenance!).toString();
      carWashFeesController.text = (_originalCarWash!).toString();
      computedRentCents = ((_originalRent ?? 0) * 100).round();
    }

    final rent = Rent(
      taxiNo: taxiNoController.text.isNotEmpty ? taxiNoController.text : '',
      contractStartUtc: contractStartUtc,
      contractEndUtc: contractEndUtc,
      monthsCount: months,
      extraDays: extraDays,
      rentAmountCents: computedRentCents,
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
    // try {
    //   // try common formats
    //   if (firstDriverCnicController.text.trim().isNotEmpty) {
    //     try {
    //     } catch (_) {
    //       try {
    //         final df = DateFormat('dd/MM/yyyy');
        
    //       } catch (_) {
    //         try {
    //           final df2 = DateFormat('dd MMM, yyyy');
              
    //         } catch (_) {
    //         }
    //       }
    //     }
    //   }
    // } catch (_) {
    // }

    // collect validation errors: rent.validate() + required CNIC
    final errors = <String, String>{};
    errors.addAll(rent.validate());
    if (firstDriverCnicController.text.trim().isEmpty ||
        firstDriverCnicController.text.trim() == '') {
      errors['driverCnic'] = 'Driver CNIC is required.';
    }

    // Additional required-field checks
    if (taxiNoController.text.trim().isEmpty) {
      errors['taxiNo'] = 'Taxi number is required.';
    }
    if (numberPlateController.text.trim().isEmpty) {
      errors['numberPlate'] = 'Number plate is required.';
    }
    if (fleetNoController.text.trim().isEmpty) {
      errors['fleetNo'] = 'Fleet number is required.';
    }
    if (firstDriverNameController.text.trim().isEmpty) {
      errors['firstDriverName'] = 'Driver name is required.';
    }
    if (firstDriverDobController.text.trim().isEmpty) {
      errors['firstDriverDob'] = 'Driver DOB is required.';
    }
    if (rentAmountController.text.trim().isEmpty || rentCents <= 0) {
      errors['rentAmount'] =
          'Rent amount is required and must be greater than 0.';
    }
    if (maintenanceCents <= 0) {
      errors['maintenanceFees'] = 'Maintenance fees must be greater than 0.';
    }
    if (carWashCents <= 0) {
      errors['carWashFees'] = 'Car wash fees must be greater than 0.';
    }
    // Payment validation
    if (paymentCashController.text.trim().isEmpty || paymentCashCents <= 0) {
      errors['paymentCash'] =
          'Payment in cash is required and must be greater than 0.';
    }
    if (paymentGCashCents < 0) {
      errors['paymentGCash'] = 'Payment in G-Cash must be 0 or greater.';
    }
    if ((paymentCashCents <= 0 && paymentGCashCents <= 0)) {
      errors['payments'] = 'At least one payment required.';
    }
    if (paymentDateController.text.trim().isEmpty) {
      errors['paymentDate'] = 'Payment date is required.';
    }
    // If GCash > 0, ref is required
    if (paymentGCashCents > 0 && gCashRefController.text.trim().isEmpty) {
      errors['gCashRef'] =
          'G-Cash Ref. No is required if G-Cash payment is entered.';
    }

    // update computed fields in UI
    int total = rent.totalCents;
    int due = rent.dueRentCents;
    if (birthday) {
      total = 0;
      due = 0;
    } else if (publicHoliday) {
      total = (rent.totalCents / 2).round();
      due = total - paymentCashCents - paymentGCashCents;
    } else {
      due = total - paymentCashCents - paymentGCashCents;
    }
    if (due < 0) due = 0;
    totalRentController.text = '${(total / 100).toStringAsFixed(0)} P';
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
    // _cubit.close();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectionState = context.read<SelectionCubit>().state;
      final cubitState = _cubit.state;
      if (cubitState is DailyRentLoaded) {
        // Pre-fill from cubit state if available
        final carInfo = cubitState.carInfo;
        final driver = cubitState.driver;
        final rent = cubitState.rent;
        if (carInfo != null) {
          taxiNoController.text = carInfo.taxiNo;
          numberPlateController.text = carInfo.plateNumber ?? '';
          fleetNoController.text = carInfo.fleetNo ?? '';
          carStatusOnRoad = carInfo.onRoad;
        } else {
          taxiNoController.text = selectionState.taxiNo;
        }
        if (driver != null) {
          firstDriverNameController.text = driver.firstDriverName;
          firstDriverCnicController.text = driver.firstDriverCnic;
          firstDriverDobController.text = driver.firstDriverDobUtc != null
              ? _formatDate(
                  DateTime.fromMillisecondsSinceEpoch(
                    driver.firstDriverDobUtc!,
                    isUtc: true,
                  ),
                )
              : '';
          secondDriverNameController.text = driver.secondDriverName ?? '';
          secondDriverCnicController.text = driver.secondDriverCnic ?? '';
          secondDriverDobController.text = driver.secondDriverDobUtc != null
              ? _formatDate(
                  DateTime.fromMillisecondsSinceEpoch(
                    driver.secondDriverDobUtc!,
                    isUtc: true,
                  ),
                )
              : '';
        } else {
          firstDriverNameController.text = selectionState.driverName;
        }
        if (rent != null) {
          totalRentController.text = '${(rent.totalCents / 100).toStringAsFixed(0)} P';
          rentAmountController.text = (rent.rentAmountCents / 100).toString();
          dueRentController.text = (rent.dueRentCents / 100).toString();
          paymentCashController.text = (rent.paymentCashCents / 100).toString();
          paymentGCashController.text = (rent.paymentGCashCents / 100)
              .toString();
          gCashRefController.text = rent.gCashRef ?? '';
          maintenanceFeesController.text = (rent.maintenanceFeesCents / 100)
              .toString();
          carWashFeesController.text = (rent.carWashFeesCents / 100).toString();
          contractStartController.text = rent.contractStartUtc != null
              ? _formatDate(
                  DateTime.fromMillisecondsSinceEpoch(
                    rent.contractStartUtc!,
                    isUtc: true,
                  ),
                )
              : '';
          contractEndController.text = rent.contractEndUtc != null
              ? _formatDate(
                  DateTime.fromMillisecondsSinceEpoch(
                    rent.contractEndUtc!,
                    isUtc: true,
                  ),
                )
              : '';
          contractMonthsController.text = rent.monthsCount.toString();
          contractExtraDaysController.text = rent.extraDays.toString();
          paymentDateController.text = _formatDate(
            DateTime.fromMillisecondsSinceEpoch(rent.createdAtUtc, isUtc: true),
          );
          publicHoliday = rent.isPublicHoliday;
          birthday = rent.isBirthday;
        } else {
          // Set defaults if no rent
          final today = DateTime.now();
          contractStartController.text = _formatDate(today);
          final twoYears = DateTime(today.year + 2, today.month, today.day);
          contractEndController.text = _formatDate(twoYears);
          paymentDateController.text = _formatDate(today);
          firstDriverDobController.text = _formatDate(today);
          secondDriverDobController.text = _formatDate(today);
        }
      } else {
        // No cubit state, set defaults
        taxiNoController.text = selectionState.taxiNo;
        firstDriverNameController.text = selectionState.driverName;
        final today = DateTime.now();
        contractStartController.text = _formatDate(today);
        final twoYears = DateTime(today.year + 2, today.month, today.day);
        contractEndController.text = _formatDate(twoYears);
        paymentDateController.text = _formatDate(today);
        firstDriverDobController.text = _formatDate(today);
        secondDriverDobController.text = _formatDate(today);
      }
      // update draft with loaded or default values
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _updateDraftFromControllers(),
      );
    });
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
                                        isReadOnly: true,
                                        errorText: fieldErrors['taxiNo'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: firstDriverNameController,
                                        labelText: 'First Driver Name',
                                        hintText: 'Enter Driver Name',
                                        isReadOnly: true,
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
                                        labelText: 'Date of Birth',
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
                                        labelText: 'Date of Birth',
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
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Column(
                                  children: [
                                    SizedBox(height: 48.h), // Space for Taxi No row
                                    Checkbox(
                                      value: _firstDriverSelected,
                                      onChanged: (v) => setState(() {
                                        _firstDriverSelected = v ?? false;
                                        if (_firstDriverSelected) {
                                          _secondDriverSelected = false;
                                        }
                                      }),
                                      activeColor: Colors.greenAccent,
                                    ),
                                    SizedBox(height: 24.h),
                                    Checkbox(
                                      value: _secondDriverSelected,
                                      onChanged: (v) => setState(() {
                                        _secondDriverSelected = v ?? false;
                                        if (_secondDriverSelected) {
                                          _firstDriverSelected = false;
                                        }
                                      }),
                                      activeColor: Colors.greenAccent,
                                    ),
                                  ],
                                ),
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
                                    Checkbox(
                                      value: _firstDriverSelected,
                                      onChanged: (v) => setState(() {
                                        _firstDriverSelected = v ?? false;
                                        if (_firstDriverSelected) {
                                          _secondDriverSelected = false;
                                        }
                                      }),
                                      activeColor: Colors.greenAccent,
                                    ),
                                  ],
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
                                        labelText: 'Date of Birth',
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
                                    Checkbox(
                                      value: _secondDriverSelected,
                                      onChanged: (v) => setState(() {
                                        _secondDriverSelected = v ?? false;
                                        if (_secondDriverSelected) {
                                          _firstDriverSelected = false;
                                        }
                                      }),
                                      activeColor: Colors.greenAccent,
                                    ),
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
                          // Do not modify rentAmountController for public holiday
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
                                // Expanded(
                                //   child: Column(
                                //     children: [
                                //       AppTextFormField(
                                //         controller: contractStartController,
                                //         labelText: 'Contract Start',
                                //         hintText: 'DD/MM/YYYY',
                                //         suffix: Icon(
                                //           Icons.calendar_today,
                                //           color: Colors.white54,
                                //           size: 18,
                                //         ),
                                //         isReadOnly: true,
                                //         onTap: () => _pickDateForController(
                                //           contractStartController,
                                //         ),
                                //         errorText: fieldErrors['contractStart'],
                                //       ),
                                //       SizedBox(height: 12.h),
                                //       AppTextFormField(
                                //         controller: contractEndController,
                                //         labelText: 'Contract End',
                                //         hintText: 'DD/MM/YYYY',
                                //         suffix: Icon(
                                //           Icons.calendar_today,
                                //           color: Colors.white54,
                                //           size: 18,
                                //         ),
                                //         isReadOnly: true,
                                //         onTap: () => _pickDateForController(
                                //           contractEndController,
                                //         ),
                                //         errorText: fieldErrors['contractEnd'],
                                //       ),
                                //       SizedBox(height: 12.h),
                                //       AppTextFormField(
                                //         controller: contractExtraDaysController,
                                //         labelText: 'Extra Days',
                                //         hintText: '0',
                                //         onChanged: (s) =>
                                //             _updateDraftFromControllers(),
                                //         errorText: fieldErrors['extraDays'],
                                //       ),
                                //       SizedBox(height: 12.h),
                                //       AppTextFormField(
                                //         controller: contractMonthsController,
                                //         labelText: 'No. of Months (auto)',
                                //         hintText: '0',
                                //         isReadOnly: true,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(width: 16.w),

                                // Left Column: Rent Type, Payment in Cash, Maintenance Fees, Payment Date
                                Expanded(
                                  child: Column(
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
                                        controller: maintenanceFeesController,
                                        labelText: 'Maintenance Fees',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText:
                                            fieldErrors['maintenanceFees'],
                                        isReadOnly: true,
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
                                // Middle Column: Total Rent Collected, Payment in G-Cash, Car Wash Fees
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: totalRentController,
                                        labelText: 'Total Rent Collected',
                                        hintText: '1000 P',
                                        isReadOnly: true,
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
                                        controller: carWashFeesController,
                                        labelText: 'Car Wash Fees',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['carWashFees'],
                                        isReadOnly: true,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // Right Column: Due Rent, G-Cash Ref. No
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextFormField(
                                        controller: dueRentController,
                                        labelText: 'Due Rent',
                                        hintText: 'Due',
                                        isReadOnly: true,
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
                          final CarInfo carInfo = CarInfo(
                            id: numberPlateController.text,
                            taxiNo: taxiNoController.text,
                            createdAtUtc: DateTime.now()
                                .toUtc()
                                .millisecondsSinceEpoch,
                            fleetNo: fleetNoController.text,
                            onRoad: carStatusOnRoad,
                            plateNumber: numberPlateController.text,
                          );
                          final Driver driver = Driver(
                            id: firstDriverCnicController.text,
                            firstDriverCnic: firstDriverCnicController.text,
                            firstDriverName: firstDriverNameController.text,
                            firstDriverDobUtc:
                                HelperFunctions.utcFromController(
                                  firstDriverDobController,
                                ),
                            createdAtUtc:
                                HelperFunctions.currentUtcTimeMilliSeconds(),
                          );
                          final Rent rent = Rent(
                            carWashFeesCents:
                                double.tryParse(
                                  carWashFeesController.text,
                                )?.toInt() ??
                                0,
                            maintenanceFeesCents:
                                double.tryParse(
                                  maintenanceFeesController.text,
                                )?.toInt() ??
                                0,
                            taxiNo: taxiNoController.text,
                            contractStartUtc: HelperFunctions.utcFromController(
                              contractStartController,
                            ),
                            rentAmountCents:
                                double.tryParse(
                                  rentAmountController.text,
                                )?.toInt() ??
                                0,
                            createdAtUtc:
                                HelperFunctions.currentUtcTimeMilliSeconds(),
                            paymentCashCents:
                                double.tryParse(
                                  paymentCashController.text,
                                )?.toInt() ??
                                0,
                            paymentGCashCents:
                                double.tryParse(
                                  paymentGCashController.text,
                                )?.toInt() ??
                                0,
                            gCashRef: gCashRefController.text,
                            isBirthday: birthday,
                            isPublicHoliday: publicHoliday,
                            monthsCount: Rent.computeMonthsCountFromTimestamps(
                              HelperFunctions.utcFromController(
                                contractStartController,
                              ),
                              HelperFunctions.utcFromController(
                                contractEndController,
                              ),
                            ),
                            extraDays:
                                int.tryParse(
                                  contractExtraDaysController.text,
                                ) ??
                                0,
                          );

                          final currentState = _cubit.state;
                          Map<String, String> errors = {};
                          if (currentState is DailyRentLoaded) {
                            errors = currentState.fieldErrors;
                          }
                          if (errors.isNotEmpty) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please fill all required fields.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            return;
                          }
                          if (context.mounted) {
                            _cubit.update(
                              carInfo: carInfo,
                              driver: driver,
                              rent: rent,
                              fieldErrors: errors,
                            );
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
