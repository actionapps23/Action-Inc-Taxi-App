// ignore_for_file: must_be_immutable

import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:action_inc_taxi_app/core/models/future_purchase_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_text_button.dart';
import 'package:action_inc_taxi_app/core/widgets/entry_field_popup.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/field/field_cubit.dart';
import 'package:action_inc_taxi_app/cubit/field/field_state.dart';
import 'package:action_inc_taxi_app/cubit/future_purchase/future_purchase_cubit.dart';
import 'package:action_inc_taxi_app/cubit/future_purchase/future_purchase_state.dart';
import 'package:action_inc_taxi_app/cubit/purchase/purchase_cubit.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/features/purchase/edit_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChecklistTable<T> extends StatelessWidget {
  final String title;
  final bool isFromFutureCarPurchase;
  final List<FieldEntryModel>? data;
  final void Function(FieldEntryModel item, bool completed)? onToggleComplete;
  FieldCubit? fieldCubit;
  FuturePurchaseCubit? futurePurchaseCubit;
  final double? maxHeight;
  final bool showUpdateTaxiNumberButton;

  ChecklistTable({
    super.key,
    required this.title,
    this.onToggleComplete,
    this.data,
    this.isFromFutureCarPurchase = false,
    this.maxHeight,
    this.fieldCubit,
    this.futurePurchaseCubit,
    this.showUpdateTaxiNumberButton = false,
  });

  Widget _headerCell(String text, {double flex = 1}) {
    return Expanded(
      flex: (flex * 1000).toInt(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        child: ResponsiveText(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _dataCell(Widget child, {double flex = 1}) {
    return Expanded(
      flex: (flex * 1000).toInt(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SelectionCubit selectionCubit = context.read<SelectionCubit>();
    final PurchaseCubit purchaseCubit = context.read<PurchaseCubit>();
    late FieldEntryModel fieldEntryModel;
    List<FieldEntryModel>? fieldEntires =
        fieldCubit != null && fieldCubit!.state is FieldEntriesLoaded
        ? (fieldCubit!.state as FieldEntriesLoaded).entries
        : null;
        
    if (fieldCubit == null && !isFromFutureCarPurchase) {
      fieldCubit ??= context.read<FieldCubit>();
    }
    futurePurchaseCubit ??= context.read<FuturePurchaseCubit>();
    final table = Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191d19),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Container()),

                      ResponsiveText(
                        title,
                        style: AppTextStyles.bodyExtraSmall,
                      ),
                      Spacer(),
                      Column(
                        children: [
                          AppOutlineButton(
                            label: "Add New field",
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EntryFieldPopup(
                                  fieldCubit: fieldCubit,
                                  isFromFutureCarPurchase: isFromFutureCarPurchase,
                                  futurePurchaseCubit: futurePurchaseCubit,
                                ),
                              );
                            },
                          ),

                          if(showUpdateTaxiNumberButton)...[
                            Spacing.vSmall,
                              AppTextButton(
                text: "Update Taxi Number",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditFieldPopup(
                        title: "Update Taxi plate number",
                        label: "Taxi plate number",
                        initialValue: selectionCubit.state.taxiPlateNo,
                        hintText: "Enter new plate number",
                        onSave: (newPlate) {
                          purchaseCubit.updateTaxiPlateNumber(
                            selectionCubit.state.taxiPlateNo,
                            newPlate,
                          );
                          selectionCubit.setTaxiPlateNo(newPlate);
                        },
                      );
                    },
                  );
                },
              ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.vLarge,
              // Header row
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    if (!isFromFutureCarPurchase) ...[
                      _headerCell('Purchase Step', flex: 3),
                      _headerCell('SOP', flex: 1),
                      _headerCell('Price', flex: 1),
                      _headerCell('Timeline', flex: 1),
                      _headerCell('Last Update', flex: 1.5),
                      _headerCell('Edit', flex: 0.6),
                      _headerCell('Check Box', flex: 0.6),
                    ] else ...[
                      _headerCell('Franchise Name', flex: 3),
                      _headerCell('Slots We Have', flex: 1),
                      _headerCell('Cars We Have', flex: 1),
                      _headerCell('Remaining Slots', flex: 1.2),
                      _headerCell('Edit', flex: 0.6),
                    ],
                  ],
                ),
              ),

              // Divider
              Divider(height: 1.h, color: Color(0xff262826)),

              // Rows list
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight ?? 400.h),
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        (isFromFutureCarPurchase
                                ? (futurePurchaseCubit != null &&
                                          futurePurchaseCubit!.state
                                              is FuturePurchaseEntriesLoaded
                                      ? (futurePurchaseCubit!.state
                                                as FuturePurchaseEntriesLoaded)
                                            .entries
                                      : [])
                                : fieldEntires ?? [])
                            .map((item) {
                              fieldEntryModel = (data?.firstWhere(
                                (element) => element.id == item.id,
                                orElse: () => item,
                              )) ?? item;
                              fieldEntires = fieldEntires?.map((e) {
                                if (e.id == item.id) {
                                  return fieldEntryModel;
                                }
                                return e;
                              }).toList();

                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _dataCell(
                                        ResponsiveText(
                                          isFromFutureCarPurchase
                                              ? item.franchiseName
                                              : fieldEntryModel.title,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: AppColors.surface,
                                              ),
                                          maxLines: 2,
                                        ),
                                        flex: 3,
                                      ),
                                      _dataCell(
                                        ResponsiveText(
                                          isFromFutureCarPurchase
                                              ? item.slotsWeHave.toString()
                                              : fieldEntryModel.SOP
                                                        .toString(),
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      ),
                                      _dataCell(
                                        ResponsiveText(
                                          isFromFutureCarPurchase
                                              ? item.carsWeHave.toString()
                                              : '${fieldEntryModel.fees} P',
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      ),
                                      _dataCell(
                                        ResponsiveText(
                                          // timeline assumed as DateTime; show relative or days if needed
                                          isFromFutureCarPurchase
                                              ? (item.slotsWeHave -
                                                        item.carsWeHave)
                                                    .toString()
                                              : HelperFunctions.formatDate(
                                                  fieldEntryModel.timeline,
                                                ),
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      ),
                                      if (!isFromFutureCarPurchase) ...[
                                        _dataCell(
                                          ResponsiveText(
                                            HelperFunctions.formatDate(
                                              fieldEntryModel.lastUpdated,
                                            ),
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                          flex: 1.5,
                                        ),
                                      ],
                                      _dataCell(
                                        IconButton(
                                          onPressed: () {
                                            if (isFromFutureCarPurchase) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    EntryFieldPopup(
                                                      fieldCubit: fieldCubit,
                                                      isFromFutureCarPurchase:
                                                          isFromFutureCarPurchase,
                                                      futurePurchaseCubit:
                                                          futurePurchaseCubit,
                                                      isUpdating: true,
                                                      futurePurchaseModel:
                                                          FuturePurchaseModel(
                                                            franchiseName: item
                                                                .franchiseName,
                                                            slotsWeHave: item
                                                                .slotsWeHave,
                                                            carsWeHave:
                                                                item.carsWeHave,
                                                            id: item.id,
                                                          ),
                                                    ),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    EntryFieldPopup(
                                                      fieldCubit: fieldCubit,
                                                      isFromFutureCarPurchase:
                                                          isFromFutureCarPurchase,
                                                      futurePurchaseCubit:
                                                          futurePurchaseCubit,
                                                      isUpdating: true,
                                                      fieldEntryModel:
                                                          FieldEntryModel(
                                                            title: item.title,
                                                            SOP: item.SOP,
                                                            fees: item.fees,
                                                            timeline:
                                                                item.timeline,
                                                            isCompleted: item
                                                                .isCompleted,
                                                          ),
                                                    ),
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: AppColors.surface,
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        flex: 0.6,
                                      ),

                                      if (!isFromFutureCarPurchase) ...[
                                        _dataCell(
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Checkbox(
                                              value: (item.isCompleted),
                                              onChanged:
                                                  onToggleComplete == null
                                                  ? null
                                                  : (v) => onToggleComplete!(
                                                      item,
                                                      v ?? false,
                                                    ),
                                            ),
                                          ),
                                          flex: 0.6,
                                        ),
                                      ],
                                    ],
                                  ),
                                  Divider(
                                    height: 1.h,
                                    color: Color(0xff262826),
                                  ),
                                ],
                              );
                            })
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // For small widths show a stacked (card) layout that's mobile-friendly.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Compute a bounded height even when parent constraints are unbounded
          final mq = MediaQuery.of(context);
          final double availableHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : mq.size.height - mq.padding.vertical - kToolbarHeight - 120.h;

          return SizedBox(
            height: availableHeight.clamp(200.h, mq.size.height),
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: ResponsiveText(
                      title,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                ),
                Spacing.vMedium,
                ...(isFromFutureCarPurchase
                        ? (futurePurchaseCubit != null &&
                                  futurePurchaseCubit!.state
                                      is FuturePurchaseEntriesLoaded
                              ? (futurePurchaseCubit!.state
                                        as FuturePurchaseEntriesLoaded)
                                    .entries
                              : [])
                        : (fieldCubit != null &&
                                  fieldCubit!.state is FieldEntriesLoaded
                              ? (fieldCubit!.state as FieldEntriesLoaded)
                                    .entries
                              : []))
                    .map((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ResponsiveText(
                              isFromFutureCarPurchase
                                  ? item.franchiseName
                                  : fieldEntryModel.title,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.surface,
                              ),
                              maxLines: 3,
                            ),
                            Spacing.vSmall,
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 8.h,
                              children: [
                                if (isFromFutureCarPurchase) ...[
                                  _infoChip(
                                    'Franchise Name',
                                    item.franchiseName.toString(),
                                  ),

                                  _infoChip(
                                    'Slots We Have',
                                    item.slotsWeHave.toString(),
                                  ),
                                  _infoChip(
                                    'Cars We Have',
                                    item.carsWeHave.toString(),
                                  ),
                                  _infoChip(
                                    'Remaining Slots',
                                    (item.slotsWeHave - item.carsWeHave)
                                        .toString(),
                                  ),
                                ] else ...[
                                  _infoChip(
                                    "Title",
                                    fieldEntryModel.title,
                                  ),
                                  _infoChip(
                                    'SOP',
                                    (fieldEntryModel.SOP)
                                        .toString(),
                                  ),
                                  _infoChip(
                                    'Price',
                                    '${fieldEntryModel.fees} P',
                                  ),
                                  _infoChip(
                                    'Timeline',
                                    HelperFunctions.formatDate(
                                      fieldEntryModel.timeline,
                                    ),
                                  ),
                                  _infoChip(
                                    'Last',
                                    HelperFunctions.formatDate(
                                      fieldEntryModel.lastUpdated,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Spacing.vSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (isFromFutureCarPurchase) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => EntryFieldPopup(
                                          fieldCubit: fieldCubit,
                                          isFromFutureCarPurchase:
                                              isFromFutureCarPurchase,
                                          futurePurchaseCubit:
                                              futurePurchaseCubit,
                                          isUpdating: true,
                                          futurePurchaseModel:
                                              FuturePurchaseModel(
                                                franchiseName:
                                                    item.franchiseName,
                                                slotsWeHave: item.slotsWeHave,
                                                carsWeHave: item.carsWeHave,
                                              ),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => EntryFieldPopup(
                                          fieldCubit: fieldCubit,
                                          isFromFutureCarPurchase:
                                              isFromFutureCarPurchase,
                                          futurePurchaseCubit:
                                              futurePurchaseCubit,
                                          isUpdating: true,
                                          fieldEntryModel: FieldEntryModel(
                                            title:
                                                fieldEntryModel.title,
                                            SOP:
                                                fieldEntryModel.SOP,
                                            fees:
                                                fieldEntryModel.fees,
                                            timeline:
                                                fieldEntryModel.timeline,
                                            isCompleted:
                                                fieldEntryModel.isCompleted,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.surface,
                                  ),
                                ),
                                if (!isFromFutureCarPurchase) ...[
                                  Checkbox(
                                    value: false,
                                    onChanged: onToggleComplete == null
                                        ? null
                                        : (v) => onToggleComplete!(
                                            fieldEntryModel,
                                            v ?? false,
                                          ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                // bottom spacing so content doesn't hit screen edge
                SizedBox(height: 24.h),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: table,
        );
      },
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.03),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: ResponsiveText(
        '$label: $value',
        style: AppTextStyles.caption.copyWith(color: AppColors.surface),
      ),
    );
  }
}
