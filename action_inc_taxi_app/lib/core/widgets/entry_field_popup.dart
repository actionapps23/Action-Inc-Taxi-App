import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:action_inc_taxi_app/core/models/future_purchase_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/date_picker_dialog.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/field/field_cubit.dart';
import 'package:action_inc_taxi_app/cubit/field/field_state.dart';
import 'package:action_inc_taxi_app/cubit/future_purchase/future_purchase_cubit.dart';
import 'package:action_inc_taxi_app/cubit/future_purchase/future_purchase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EntryFieldPopup extends StatelessWidget {
  final FieldCubit? fieldCubit;
  final FuturePurchaseCubit? futurePurchaseCubit;
  final bool isUpdating;
  final bool isFromFutureCarPurchase;
  EntryFieldPopup({
    super.key,
    this.fieldCubit,
    this.futurePurchaseCubit,
    this.isUpdating = false,
    this.isFromFutureCarPurchase = false,
  });
  final TextEditingController _fieldTitleController = TextEditingController();
  final TextEditingController _sopController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _timelineController = TextEditingController();

  final ValueNotifier<bool> _isCompleted = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: Container(
          width: 100.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResponsiveText(
                    isUpdating ? "Update Field" : "Add New Field",
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing.vLarge,
                  ResponsiveText(
                    isFromFutureCarPurchase ? 'Franchise Name' : "Field title",
                    style: AppTextStyles.bodyExtraSmall,
                  ),
                  Spacing.vSmall,
                  AppTextFormField(
                    hintText: isFromFutureCarPurchase
                        ? "Enter franchise name"
                        : "Enter field title",
                    controller: _fieldTitleController,
                  ),
                  Spacing.vLarge,
                  ResponsiveText(
                    isFromFutureCarPurchase ? "Slots we have" : "SOP",
                    style: AppTextStyles.bodyExtraSmall,
                  ),
                  Spacing.vSmall,
                  AppTextFormField(
                    hintText: isFromFutureCarPurchase
                        ? "Enter slots we have"
                        : "Enter SOP",
                    controller: _sopController,
                  ),
                  Spacing.vLarge,
                  ResponsiveText(
                    isFromFutureCarPurchase ? "Cars we have" : "Fees",
                    style: AppTextStyles.bodyExtraSmall,
                  ),
                  Spacing.vSmall,
                  AppTextFormField(
                    hintText: isFromFutureCarPurchase
                        ? "Enter cars we have"
                        : "Enter Fees",
                    controller: _feesController,
                  ),
                  Spacing.vLarge,

                  if (!isFromFutureCarPurchase) ...[
                    ResponsiveText(
                      "Timeline",
                      style: AppTextStyles.bodyExtraSmall,
                    ),
                    Spacing.vSmall,
                    AppTextFormField(
                      hintText: "Enter Timeline",
                      isReadOnly: true,
                      onTap: () {
                        showDatePickerDialog(context, _timelineController);
                        debugPrint(
                          "Picked date: \\${_timelineController.text}",
                        );
                      },
                      controller: _timelineController,
                    ),
                  ],
                  Spacing.vLarge,
                 if(!isFromFutureCarPurchase)...[
                   Row(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _isCompleted,
                        builder: (context, value, _) {
                          return Checkbox(
                            value: value,
                            onChanged: (v) => _isCompleted.value = v ?? false,
                          );
                        },
                      ),
                      ResponsiveText(
                        "Is Completed",
                        style: AppTextStyles.bodyExtraSmall,
                      ),
                    ],
                  ),
                  Spacing.vExtraLarge,
                 ],

                 if(isFromFutureCarPurchase) ...[
                    BlocBuilder<FuturePurchaseCubit, FuturePurchaseState>(
                      bloc: futurePurchaseCubit,
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: AppButton(
                            text: isUpdating
                                ? "Update"
                                : state is FuturePurchaseEntryUpdated
                                ? "Updating..."
                                : state is FuturePurchaseEntryAdding
                                ? "Adding..."
                                : "Add",
                            onPressed: () {
                              if (isUpdating) {
                              
                                  futurePurchaseCubit!.updateFieldEntry(
                                    FuturePurchaseModel(
                                      id: _fieldTitleController.text,
                                      franchiseName: _fieldTitleController.text,
                                      slotsWeHave: int.parse(_sopController.text),
                                      carsWeHave: int.parse(_feesController.text),
                                     
                                    ),
                                  );
                                
                              } else {
                                
                                  futurePurchaseCubit!.addFieldEntry(
                                    FuturePurchaseModel(
                                      id: _fieldTitleController.text,
                                      franchiseName: _fieldTitleController.text,
                                      slotsWeHave: int.parse(_sopController.text),
                                      carsWeHave: int.parse(_feesController.text),
                                 
                                    ),
                                  );
                                
                              }
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                 ]
                 else ...[ BlocBuilder<FieldCubit, FieldState>(
                    bloc: fieldCubit,
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: AppButton(
                          text: isUpdating
                              ? "Update"
                              : state is FieldEntryUpdating
                              ? "Updating..."
                              : state is FieldEntryAdding
                              ? "Adding..."
                              : "Add",
                          onPressed: () {
                            final isCompleted = _isCompleted.value;
                            if (isUpdating) {
                            
                                fieldCubit!.updateFieldEntry(
                                  FieldEntryModel(
                                    title: _fieldTitleController.text,
                                    SOP: int.parse(_sopController.text),
                                    isCompleted: isCompleted,
                                    fees: int.parse(_feesController.text),
                                    timeline:
                                        HelperFunctions.parseDateString(
                                          _timelineController.text,
                                        ) ??
                                        DateTime.now(),
                                  ),
                                );
                              
                            } else {
                              
                                fieldCubit!.addFieldEntry(
                                  FieldEntryModel(
                                    title: _fieldTitleController.text,
                                    SOP: int.parse(_sopController.text),
                                    isCompleted: isCompleted,
                                    fees: int.parse(_feesController.text),
                                    timeline:
                                        HelperFunctions.parseDateString(
                                          _timelineController.text,
                                        ) ??
                                        DateTime.now(),
                                  ),
                                );
                              
                            }
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
