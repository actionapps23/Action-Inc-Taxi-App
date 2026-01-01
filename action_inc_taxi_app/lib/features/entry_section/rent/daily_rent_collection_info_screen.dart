import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/car_info.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/cubit/car_details/car_detail_cubit.dart';
import 'package:action_inc_taxi_app/cubit/car_details/car_detail_state.dart';
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
  final bool fetchDetails;
  const DailyRentCollectionInfoScreen({super.key, this.fetchDetails = false});

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
  final regNoController = TextEditingController();
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

  // Field validators mapped by field key used in fieldErrors
  late final Map<String, String? Function(String?)> _validators = {
    'taxiNo': (v) =>
        v == null || v.trim().isEmpty ? 'Taxi number is required.' : null,
    'firstDriverName': (v) =>
        v == null || v.trim().isEmpty ? 'Driver name is required.' : null,
    'secondDriverName': (v) {
      final hasSecondDriverId =
          secondDriverCnicController.text.trim().isNotEmpty;
      if (hasSecondDriverId && (v == null || v.trim().isEmpty)) {
        return 'Second Driver name is required when ID is provided.';
      }
      return null;
    },
    'numberPlate': (v) =>
        v == null || v.trim().isEmpty ? 'Number plate is required.' : null,
    'firstDriverDob': (v) =>
        v == null || v.trim().isEmpty ? 'Driver DOB is required.' : null,
    'secondDriverDob': (v) {
      final hasSecondDriverName =
          secondDriverNameController.text.trim().isNotEmpty;
      if (hasSecondDriverName && (v == null || v.trim().isEmpty)) {
        return 'Second Driver DOB is required when name is provided.';
      }
      return null;
    },
    'fleetNo': (v) {
      if (v == null || v.trim().isEmpty) return 'Fleet number is required.';
      final val = v.trim();
      if (!RegExp(r'^[1-4]$').hasMatch(val)) {
        return 'Fleet number must be 1, 2, 3 or 4.';
      }
      return null;
    },
    'firstDriverCnic': (v) =>
        v == null || v.trim().isEmpty ? 'Driver CNIC is required.' : null,
    'secondDriverCnic': (v) {
      final hasSecondDriverName =
          secondDriverNameController.text.trim().isNotEmpty;
      if (hasSecondDriverName && (v == null || v.trim().isEmpty)) {
        return 'Second Driver ID # is required when name is provided.';
      }
      return null;
    },
    'rentAmount': (v) {
      final raw = (v ?? '').replaceAll(RegExp(r'[^0-9\.]'), '');
      final d = double.tryParse(raw);
      if (d == null || d <= 0) {
        return 'Rent amount is required and must be greater than 0.';
      }
      return null;
    },
    'maintenanceFees': (v) {
      final raw = (v ?? '').replaceAll(RegExp(r'[^0-9\.]'), '');
      final d = double.tryParse(raw);
      if (d == null || d <= 0) {
        return 'Maintenance fees must be greater than 0.';
      }
      return null;
    },
    'carWashFees': (v) {
      final raw = (v ?? '').replaceAll(RegExp(r'[^0-9\.]'), '');
      final d = double.tryParse(raw);
      if (d == null || d <= 0) return 'Car wash fees must be greater than 0.';
      return null;
    },
    'paymentCash': (v) {
      final raw = (v ?? '').replaceAll(RegExp(r'[^0-9\.]'), '');
      final d = double.tryParse(raw);
      if (d == null || d <= 0)
        return 'Payment in cash is required and must be greater than 0.';
      return null;
    },
    'paymentGCash': (v) {
      final raw = (v ?? '').replaceAll(RegExp(r'[^0-9\.]'), '');
      final d = double.tryParse(raw);
      if (d == null || d < 0) return 'Payment in G-Cash must be 0 or greater.';
      return null;
    },
    'regNo': (v) =>
        v == null || v.trim().isEmpty ? 'Registration number is required.' : null
    ,
    'paymentDate': (v) =>
        v == null || v.trim().isEmpty ? 'Payment date is required.' : null,
    'gCashRef': (v) {
      final gcashRaw = paymentGCashController.text.replaceAll(
        RegExp(r'[^0-9\.]'),
        '',
      );
      final gcash = double.tryParse(gcashRaw) ?? 0.0;
      if (gcash > 0 && (v == null || v.trim().isEmpty)) {
        return 'G-Cash Ref. No is required if G-Cash payment is entered.';
      }
      return null;
    },
    'extraDays': (v) {
      final n = int.tryParse((v ?? '').trim()) ?? 0;
      if (n < 0) return 'Extra days must be 0 or greater.';
      return null;
    },
  };

  bool carStatusOnRoad = true;
  bool publicHoliday = false;
  bool birthday = false;
  bool mainCheck = true;
  bool secondCheck = false;

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

    final int? paymentDateUtc = _parseDateToUtcMs(
      paymentDateController.text.trim(),
    );
    final dateKey = HelperFunctions.generateDateKeyFromUtc(
      paymentDateUtc ?? DateTime.now().toUtc().millisecondsSinceEpoch,
    );

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
      dateKey: dateKey,
    );

    // collect validation errors: rent.validate() + required CNIC
    final errors = <String, String>{};
    errors.addAll(rent.validate());
    if (firstDriverCnicController.text.trim().isEmpty ||
        firstDriverCnicController.text.trim() == '') {
      errors['firstDriverCnic'] = 'Driver CNIC is required.';
    }

    // Additional required-field checks
    if (taxiNoController.text.trim().isEmpty) {
      errors['taxiNo'] = 'Taxi number is required.';
    }
    if (numberPlateController.text.trim().isEmpty) {
      errors['numberPlate'] = 'Number plate is required.';
    }
    if(secondDriverCnicController.text.trim().isEmpty && secondDriverNameController.text.trim().isNotEmpty) {
      errors['secondDriverCnic'] = 'Second Driver ID # is required when name is provided.';
    }
    if(secondDriverNameController.text.trim().isEmpty && secondDriverCnicController.text.trim().isNotEmpty) {
      errors['secondDriverName'] = 'Second Driver name is required when ID is provided.';
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
    // update cubit with validation errors so UI can display them
    try {
      _cubit.update(fieldErrors: errors);
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

  Rent? rent;
  Driver? driver;
  CarInfo? carInfo;
  @override
  void initState() {
    super.initState();
    firstDriverNameController.addListener(() {
      final v = firstDriverNameController.text;
      debugPrint('DEBUG firstDriverNameController -> "$v"');
      if (v.isEmpty) {
        debugPrint(
          'DEBUG firstDriverNameController emptied here:\n${StackTrace.current}',
        );
      }
    });
    final CarDetailCubit carDetailCubit = context.read<CarDetailCubit>();
    final CarDetailState carDetailState = carDetailCubit.state;

    if (widget.fetchDetails ||( carDetailState is CarDetailLoaded && carDetailState.carDetailModel != null)) {
      rent = carDetailState.carDetailModel!.rent;
      driver = carDetailState.carDetailModel!.driver;
      carInfo = carDetailState.carDetailModel!.carInfo;

      firstDriverCnicController.text = driver?.firstDriverCnic ?? '';
      firstDriverDobController.text = HelperFunctions.formatDateFromUtcMillis(
        driver?.firstDriverDobUtc,
      );
      firstDriverNameController.text = driver?.firstDriverName ?? '';
      taxiNoController.text = carInfo?.taxiNo ?? '';
      numberPlateController.text = carInfo?.plateNumber ?? '';
      fleetNoController.text = carInfo?.fleetNo ?? '';
      carStatusOnRoad = carInfo?.onRoad ?? true;

      secondDriverCnicController.text = driver?.secondDriverCnic ?? '';
      secondDriverDobController.text = HelperFunctions.formatDateFromUtcMillis(
        driver?.secondDriverDobUtc,
      );
      secondDriverNameController.text = driver?.secondDriverName ?? '';
      contractExtraDaysController.text = rent?.extraDays.toString() ?? '0';
      contractStartController.text = HelperFunctions.formatDateFromUtcMillis(
        rent?.contractStartUtc,
      );
      contractEndController.text = HelperFunctions.formatDateFromUtcMillis(
        rent?.contractEndUtc,
      );
      contractMonthsController.text = rent?.monthsCount.toString() ?? '0';
      paymentDateController.text = HelperFunctions.formatDateFromUtcMillis(
        rent?.createdAtUtc,
      );
      gCashRefController.text = rent?.gCashRef ?? '';
      rentAmountController.text = ((rent?.rentAmountCents ?? 0)).toString();
      dueRentController.text = ((rent?.dueRentCents ?? 0)).toString();
      totalRentController.text = ((rent?.totalCents ?? 0)).toString();
      paymentCashController.text = ((rent?.paymentCashCents ?? 0)).toString();
      paymentGCashController.text = ((rent?.paymentGCashCents ?? 0)).toString();
      gCashRefController.text = rent?.gCashRef ?? '';
      maintenanceFeesController.text = ((rent?.maintenanceFeesCents ?? 0))
          .toString();
      carWashFeesController.text = ((rent?.carWashFeesCents ?? 0)).toString();
      publicHoliday = rent?.isPublicHoliday ?? false;
      birthday = rent?.isBirthday ?? false;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectionState = context.read<SelectionCubit>().state;
      final cubitState = _cubit.state;
      if (cubitState is DailyRentLoaded) {
        final carInfo = cubitState.carInfo;
        final driver = cubitState.driver;
        final rent = cubitState.rent;
        if (carInfo != null && !widget.fetchDetails) {
          taxiNoController.text = carInfo.taxiNo;
          numberPlateController.text = carInfo.plateNumber ?? '';
          fleetNoController.text = carInfo.fleetNo ?? '';
          carStatusOnRoad = carInfo.onRoad;
        } else if (!widget.fetchDetails) {
          taxiNoController.text = selectionState.taxiNo;
        }
        if (driver != null && !widget.fetchDetails) {
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
        } else if (!widget.fetchDetails) {
          firstDriverNameController.text = selectionState.driverName;
        }
        if (rent != null && !widget.fetchDetails) {
          totalRentController.text = (rent.totalCents / 100).toString();
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
        } else if (!widget.fetchDetails) {
          // Set defaults if no rent
          final today = DateTime.now();
          contractStartController.text = _formatDate(today);
          final twoYears = DateTime(today.year + 2, today.month, today.day);
          contractEndController.text = _formatDate(twoYears);
          paymentDateController.text = _formatDate(today);
          firstDriverDobController.text = _formatDate(today);
          secondDriverDobController.text = _formatDate(today);
        }
      } else if (!widget.fetchDetails) {
        // No cubit state, set defaults but don't overwrite existing values
        if (taxiNoController.text.trim().isEmpty) {
          taxiNoController.text = selectionState.taxiNo;
        }
        if (firstDriverNameController.text.trim().isEmpty) {
          firstDriverNameController.text = selectionState.driverName;
        }
        if(regNoController.text.trim().isEmpty) {
          regNoController.text = selectionState.regNo;
        }
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
                      ResponsiveText(
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
                          ResponsiveText(
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
                          ResponsiveText(
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
                          ResponsiveText(
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
                                        validator: _validators['taxiNo'],
                                        errorText: fieldErrors['taxiNo'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: firstDriverNameController,
                                        labelText: 'Regular Driver Name',
                                        hintText: 'Enter Regular Driver Name',
                                        isReadOnly: true,
                                        validator:
                                            _validators['firstDriverName'],
                                        errorText:
                                            fieldErrors['firstDriverName'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: secondDriverNameController,
                                        labelText: 'Second Driver',
                                        hintText: 'Enter Second Driver',
                                        isReadOnly: widget.fetchDetails,
                                        validator:
                                            _validators['secondDriverName'],
                                        errorText:
                                            fieldErrors['secondDriverName'],
                                      ),
                                       SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: secondDriverCnicController,
                                        labelText: 'Second Driver ID #',
                                        hintText: 'Enter Driver ID #',
                                        isReadOnly: widget.fetchDetails,
                                        validator: _validators['secondDriverCnic'],
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['secondDriverCnic'],
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
                                        isReadOnly: widget.fetchDetails,
                                        validator: _validators['numberPlate'],
                                        errorText: fieldErrors['numberPlate'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: firstDriverDobController,
                                        labelText: 'Regular Driver DOB',
                                        hintText: 'DD MMM, YYYY',
                                        isReadOnly: true,
                                        onTap: widget.fetchDetails
                                            ? null
                                            : () => _pickDateForController(
                                                firstDriverDobController,
                                              ),
                                        validator:
                                            _validators['firstDriverDob'],
                                        errorText:
                                            fieldErrors['firstDriverDob'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: secondDriverDobController,
                                        labelText: 'Second Driver DOB',
                                        hintText: 'DD MMM, YYYY',
                                        isReadOnly: true,
                                        onTap: widget.fetchDetails
                                            ? null
                                            : () => _pickDateForController(
                                                secondDriverDobController,
                                              ),
                                        validator:
                                            _validators['secondDriverDob'],
                                        errorText:
                                            fieldErrors['secondDriverDob'],
                                      ),
                                       SizedBox(height: 12.h),

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
                                        onTap: widget.fetchDetails
                                            ? null
                                            : () => _pickDateForController(
                                                contractStartController,
                                              ),
                                        validator: _validators['paymentDate'],
                                        errorText: fieldErrors['contractStart'],
                                      ),
                                      SizedBox(height: 12.h),
                                     
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    children: [
                                       AppTextFormField(
                                        controller: regNoController,
                                        labelText: 'Reg No',
                                        hintText: 'Enter Reg No',
                                        isReadOnly: widget.fetchDetails,
                                        validator: _validators['regNo'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: fleetNoController,
                                        labelText: 'Fleet No',
                                        hintText: 'Enter Fleet No',
                                        isReadOnly: widget.fetchDetails,
                                        validator: _validators['fleetNo'],
                                        errorText: fieldErrors['fleetNo'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: firstDriverCnicController,
                                        labelText: 'First Driver ID #',
                                        hintText: 'Enter Driver ID #',
                                        isReadOnly: widget.fetchDetails,
                                        validator: _validators['firstDriverCnic'],
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        errorText: fieldErrors['firstDriverCnic'],
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
                                        onTap: widget.fetchDetails
                                            ? null
                                            : () => _pickDateForController(
                                                contractEndController,
                                              ),
                                        validator: _validators['paymentDate'],
                                        errorText: fieldErrors['contractEnd'],
                                      ),
                                     
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                              ],
                            )
                          : Column(
                              children: [
                                AppTextFormField(
                                  controller: taxiNoController,
                                  labelText: 'Taxi No',
                                  hintText: 'Enter Taxi No',
                                  isReadOnly: widget.fetchDetails,
                                  validator: _validators['taxiNo'],
                                  errorText: fieldErrors['taxiNo'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: numberPlateController,
                                  labelText: 'Number Plate',
                                  hintText: 'Enter Number Plate',
                                  isReadOnly: widget.fetchDetails,
                                  validator: _validators['numberPlate'],
                                  errorText: fieldErrors['numberPlate'],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: fleetNoController,
                                        labelText: 'Fleet No',
                                        hintText: 'Enter Fleet No',
                                        isReadOnly: widget.fetchDetails,
                                        validator: _validators['fleetNo'],
                                        errorText: fieldErrors['fleetNo'],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: regNoController,
                                        labelText: 'Reg No',
                                        hintText: 'Enter Reg No',
                                        isReadOnly: widget.fetchDetails,
                                        validator: _validators['regNo'],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: firstDriverNameController,
                                  labelText: 'Regular Driver Name',
                                  hintText: 'Enter Regular Driver Name',
                                  isReadOnly: widget.fetchDetails,
                                  validator: _validators['firstDriverName'],
                                  errorText: fieldErrors['firstDriverName'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: firstDriverDobController,
                                  labelText: 'Regular Driver DOB',
                                  hintText: 'DD/MM/YYYY',
                                  isReadOnly: true,
                                  onTap: widget.fetchDetails
                                      ? null
                                      : () => _pickDateForController(
                                          firstDriverDobController,
                                        ),
                                  validator: _validators['firstDriverDob'],
                                  errorText: fieldErrors['firstDriverDob'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: firstDriverCnicController,
                                  labelText: 'First Driver ID #',
                                  hintText: 'Enter Driver ID #',
                                  isReadOnly: widget.fetchDetails,
                                  validator: _validators['firstDriverCnic'],
                                  onChanged: (s) => _updateDraftFromControllers(),
                                  errorText: fieldErrors['firstDriverCnic'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: secondDriverNameController,
                                  labelText: 'Second Driver',
                                  hintText: 'Enter Second Driver',
                                  isReadOnly: widget.fetchDetails,
                                  validator: _validators['secondDriverName'],
                                  errorText: fieldErrors['secondDriverName'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: secondDriverDobController,
                                  labelText: 'Second Driver DOB',
                                  hintText: 'DD/MM/YYYY',
                                  isReadOnly: true,
                                  onTap: widget.fetchDetails
                                      ? null
                                      : () => _pickDateForController(
                                          secondDriverDobController,
                                        ),
                                  validator: _validators['secondDriverDob'],
                                  errorText: fieldErrors['secondDriverDob'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: secondDriverCnicController,
                                  labelText: 'Second Driver ID #',
                                  hintText: 'Enter Driver ID #',
                                  isReadOnly: widget.fetchDetails,
                                  validator: _validators['secondDriverCnic'],
                                  onChanged: (s) => _updateDraftFromControllers(),
                                  errorText: fieldErrors['secondDriverCnic'],
                                ),
                                SizedBox(height: 12.h),
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
                                  onTap: widget.fetchDetails
                                      ? null
                                      : () => _pickDateForController(
                                          contractStartController,
                                        ),
                                  validator: _validators['paymentDate'],
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
                                  onTap: widget.fetchDetails
                                      ? null
                                      : () => _pickDateForController(
                                          contractEndController,
                                        ),
                                  validator: _validators['paymentDate'],
                                  errorText: fieldErrors['contractEnd'],
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
                      Flexible(
                        child: ResponsiveText(
                          'Public Holiday(Half Rent)',
                          style: TextStyle(color: Colors.white),
                        ),
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
                      Flexible(
                        child: ResponsiveText(
                          'Birthday(Zero Rent)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  ResponsiveText(
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
                                        controller: contractExtraDaysController,
                                        labelText: 'Extra Days',
                                        hintText: '0',
                                        isReadOnly: widget.fetchDetails,
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        validator: _validators['extraDays'],
                                        errorText: fieldErrors['extraDays'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: contractMonthsController,
                                        labelText: 'No. of Months (auto)',
                                        hintText: '0',
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
                                        onTap: widget.fetchDetails
                                            ? null
                                            : () => _pickDateForController(
                                                paymentDateController,
                                              ),
                                        validator: _validators['paymentDate'],
                                        errorText: fieldErrors['paymentDate'],
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
                                        isReadOnly: widget.fetchDetails,
                                        onChanged: (s) {
                                          if (birthday) {
                                            // Do not change rentAmountController, just skip further logic
                                            return;
                                          }
                                          // Do not modify rentAmountController for public holiday
                                          _updateDraftFromControllers();
                                        },
                                        validator: _validators['rentAmount'],
                                        errorText: fieldErrors['rentAmount'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: maintenanceFeesController,
                                        labelText: 'Maintenance Fees',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        validator:
                                            _validators['maintenanceFees'],
                                        errorText:
                                            fieldErrors['maintenanceFees'],
                                        isReadOnly: widget.fetchDetails,
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: carWashFeesController,
                                        labelText: 'Car Wash Fees',
                                        hintText: 'Enter Amount',
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        validator: _validators['carWashFees'],
                                        errorText: fieldErrors['carWashFees'],
                                        isReadOnly: widget.fetchDetails,
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
                                        isReadOnly: widget.fetchDetails,
                                        suffix: Icon(
                                          Icons.money,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        validator: _validators['paymentCash'],
                                        errorText: fieldErrors['paymentCash'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: paymentGCashController,
                                        labelText: 'Payment in G-Cash',
                                        hintText: 'Enter Amount',
                                        isReadOnly: widget.fetchDetails,
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        validator: _validators['paymentGCash'],
                                        errorText: fieldErrors['paymentGCash'],
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: gCashRefController,
                                        labelText: 'G-Cash Ref. No',
                                        hintText: 'Enter Ref',
                                        isReadOnly: widget.fetchDetails,
                                        onChanged: (s) =>
                                            _updateDraftFromControllers(),
                                        validator: _validators['gCashRef'],
                                        errorText: fieldErrors['gCashRef'],
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
                                        isReadOnly: true,
                                      ),
                                      SizedBox(height: 12.h),
                                      AppTextFormField(
                                        controller: dueRentController,
                                        labelText: 'Due Rent (computed)',
                                        hintText: 'Due',
                                        isReadOnly: true,
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                AppTextFormField(
                                  controller: contractExtraDaysController,
                                  labelText: 'Extra Days',
                                  hintText: '0',
                                  isReadOnly: widget.fetchDetails,
                                  onChanged: (s) => _updateDraftFromControllers(),
                                  validator: _validators['extraDays'],
                                  errorText: fieldErrors['extraDays'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: contractMonthsController,
                                  labelText: 'No. of Months (auto)',
                                  hintText: '0',
                                  isReadOnly: true,
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: rentAmountController,
                                  labelText: 'Rent Amount',
                                  hintText: 'Enter Amount',
                                  isReadOnly: widget.fetchDetails,
                                  onChanged: (s) {
                                    if (birthday) {
                                      return;
                                    }
                                    _updateDraftFromControllers();
                                  },
                                  validator: _validators['rentAmount'],
                                  errorText: fieldErrors['rentAmount'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: maintenanceFeesController,
                                  labelText: 'Maintenance Fees',
                                  hintText: 'Enter Amount',
                                  isReadOnly: widget.fetchDetails,
                                  onChanged: (s) => _updateDraftFromControllers(),
                                  validator: _validators['maintenanceFees'],
                                  errorText: fieldErrors['maintenanceFees'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: carWashFeesController,
                                  labelText: 'Car Wash Fees',
                                  hintText: 'Enter Amount',
                                  isReadOnly: widget.fetchDetails,
                                  onChanged: (s) => _updateDraftFromControllers(),
                                  validator: _validators['carWashFees'],
                                  errorText: fieldErrors['carWashFees'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: paymentCashController,
                                  labelText: 'Payment in Cash',
                                  hintText: 'Enter Amount',
                                  isReadOnly: widget.fetchDetails,
                                  suffix: Icon(
                                    Icons.money,
                                    color: Colors.white54,
                                    size: 18,
                                  ),
                                  onChanged: (s) => _updateDraftFromControllers(),
                                  validator: _validators['paymentCash'],
                                  errorText: fieldErrors['paymentCash'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: paymentGCashController,
                                  labelText: 'Payment in G-Cash',
                                  hintText: 'Enter Amount',
                                  isReadOnly: widget.fetchDetails,
                                  onChanged: (s) => _updateDraftFromControllers(),
                                  validator: _validators['paymentGCash'],
                                  errorText: fieldErrors['paymentGCash'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: gCashRefController,
                                  labelText: 'G-Cash Ref. No',
                                  hintText: 'Enter Ref',
                                  isReadOnly: widget.fetchDetails,
                                  onChanged: (s) => _updateDraftFromControllers(),
                                  validator: _validators['gCashRef'],
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
                                  onTap: widget.fetchDetails
                                      ? null
                                      : () => _pickDateForController(
                                          paymentDateController,
                                        ),
                                  validator: _validators['paymentDate'],
                                  errorText: fieldErrors['paymentDate'],
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: totalRentController,
                                  labelText: 'Total Rent (computed)',
                                  hintText: 'Total',
                                  isReadOnly: true,
                                ),
                                SizedBox(height: 12.h),
                                AppTextFormField(
                                  controller: dueRentController,
                                  labelText: 'Due Rent (computed)',
                                  hintText: 'Due',
                                  isReadOnly: true,
                                ),
                              ],
                            );
                    },
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!widget.fetchDetails) ...[
                        AppButton(
                          text: 'Next',
                          onPressed: () async {
                            _updateDraftFromControllers();
                            final CarInfo carInfo = CarInfo(
                              id: numberPlateController.text,
                              regNo: regNoController.text,
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
                              secondDriverCnic: secondDriverCnicController.text,
                              secondDriverName: secondDriverNameController.text,
                              secondDriverDobUtc:
                                  HelperFunctions.utcFromController(
                                    secondDriverDobController,
                                  ),
                              createdAtUtc:
                                  HelperFunctions.currentUtcTimeMilliSeconds(),
                            );
                            final dateKey =
                                HelperFunctions.generateDateKeyFromUtc(
                                  DateTime.now().toUtc().millisecondsSinceEpoch,
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
                              contractStartUtc:
                                  HelperFunctions.utcFromController(
                                    contractStartController,
                                  ),
                              contractEndUtc: HelperFunctions.utcFromController(
                                contractEndController,
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
                              monthsCount:
                                  Rent.computeMonthsCountFromTimestamps(
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
                              dateKey: dateKey,
                            );

                            final currentState = _cubit.state;
                            Map<String, String> errors = {};
                            if (currentState is DailyRentLoaded) {
                              errors = currentState.fieldErrors;
                            }
                            if (errors.isNotEmpty) {
                              debugPrint(
                                'Errors in form: ${errors.toString()}',
                              );
                              if (context.mounted) {
                                SnackBarHelper.showErrorSnackBar(
                                  context,
                                  'Please fix the errors in the form.',
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
                          width: MediaQuery.of(context).size.width < 600 ? 240 : 40.w,
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
