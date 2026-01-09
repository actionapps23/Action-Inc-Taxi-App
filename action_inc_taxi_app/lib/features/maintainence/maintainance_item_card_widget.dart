import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/report_issue_popup.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/core/utils/device_utils.dart';
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintainanceItemCard extends StatefulWidget {
  final MaintainanceModel maintainanceModel;
  const MaintainanceItemCard({super.key, required this.maintainanceModel});

  @override
  State<MaintainanceItemCard> createState() => _MaintainanceItemCardState();
}

class _MaintainanceItemCardState extends State<MaintainanceItemCard> {
  late bool _isSolved = widget.maintainanceModel.isResolved;
  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final deviceUtils = DeviceUtils(context);
    final MaintainanceCubit maintainanceCubit = context
        .read<MaintainanceCubit>();
    final LoginState loginState = loginCubit.state;
    final bool isAdmin = loginState is LoginSuccess && loginState.user.isAdmin;

    final bool isMobile = deviceUtils.isSmallMobile || deviceUtils.isMediumMobile || deviceUtils.isExtraSmallMobile;

    Widget titleSection = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ResponsiveText(
            widget.maintainanceModel.title,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 14.sp : 18.sp,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Chip(
            label: ResponsiveText(
              _isSolved ? 'Solved' : 'Unsolved',
              style: AppTextStyles.bodyExtraSmall.copyWith(
                fontSize: isMobile ? 10.sp : 12.sp,
              ),
            ),
            backgroundColor: _isSolved ? AppColors.success : AppColors.error,
            labelStyle: AppTextStyles.bodyExtraSmall.copyWith(
              color: Colors.white,
              fontSize: isMobile ? 10.sp : 12.sp,
            ),
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12.w : 16.w, vertical: isMobile ? 4.h : 8.h),
          ),
        ),
      ],
    );

    Widget actionButtons = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacing.vMedium,
              if (isAdmin)
                AppOutlineButton(
                  label: "Edit",
                  prefixIcon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ReportIssuePopup(
                        isEdit: true,
                        maintainanceModel: widget.maintainanceModel,
                      ),
                    );
                  },
                ),
              if (isAdmin) Spacing.vStandard,
              AppButton(
                text: _isSolved ? 'Mark as Unsolved' : 'Mark as Solved',
                backgroundColor: _isSolved ? AppColors.error : AppColors.success,
                textColor: _isSolved ? Colors.white : AppColors.buttonText,
                onPressed: () {
                  setState(() {
                    _isSolved = !_isSolved;
                  });
                  maintainanceCubit.updateMaintainanceRequest(
                    widget.maintainanceModel.copyWith(
                      isResolved: _isSolved,
                      lastUpdatedBy: loginState is LoginSuccess ? loginState.user.name : '',
                      lastUpdatedAt: DateTime.now(),
                    ),
                  );
                },
              ),
                          Spacing.vMedium,

            ]
            ,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAdmin)
                AppOutlineButton(
                  label: "Edit",
                  prefixIcon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ReportIssuePopup(
                        isEdit: true,
                        maintainanceModel: widget.maintainanceModel,
                      ),
                    );
                  },
                ),
              if (isAdmin) Spacing.hSmall,
              AppButton(
                text: _isSolved ? 'Mark as Unsolved' : 'Mark as Solved',
                backgroundColor: _isSolved ? AppColors.error : AppColors.success,
                textColor: _isSolved ? Colors.white : AppColors.buttonText,
                onPressed: () {
                  setState(() {
                    _isSolved = !_isSolved;
                  });
                  maintainanceCubit.updateMaintainanceRequest(
                    widget.maintainanceModel.copyWith(
                      isResolved: _isSolved,
                      lastUpdatedBy: loginState is LoginSuccess ? loginState.user.name : '',
                      lastUpdatedAt: DateTime.now(),
                    ),
                  );
                },
              ),
            ],
          );

    Widget attachmentsRow = isMobile
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.maintainanceModel.attachmentUrls!
                  .map(
                    (attachmentUrl) => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: InteractiveViewer(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      attachmentUrl,
                                      width: 0.9.w * MediaQuery.of(context).size.width,
                                      height: 0.7.h * MediaQuery.of(context).size.height,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 0.9.w * MediaQuery.of(context).size.width,
                                        height: 0.7.h * MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          color: Colors.blueAccent,
                                          size: 64,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Image.network(
                          attachmentUrl,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.image,
                              color: Colors.blueAccent,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        : Row(
            children: widget.maintainanceModel.attachmentUrls!
                .map(
                  (attachmentUrl) => Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: InteractiveViewer(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    attachmentUrl,
                                    width: 0.9.w * MediaQuery.of(context).size.width,
                                    height: 0.7.h * MediaQuery.of(context).size.height,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 0.9.w * MediaQuery.of(context).size.width,
                                      height: 0.7.h * MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.blueAccent,
                                        size: 64,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Image.network(
                        attachmentUrl,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image,
                            color: Colors.blueAccent,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );

    Widget infoWrap = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: isMobile ? 12 : 24,
      runSpacing: isMobile ? 4 : 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.maintainanceModel.taxiId != '') ...[
              ResponsiveText(
                "Taxi No. ",
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 10.sp : 12.sp,
                ),
              ),
              ResponsiveText(
                widget.maintainanceModel.taxiId!,
                style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: isMobile ? 10.sp : 12.sp),
              ),
            ] else if (widget.maintainanceModel.taxiPlateNumber != '') ...[
              ResponsiveText(
                "Taxi Plate No. ",
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 10.sp : 12.sp,
                ),
              ),
              ResponsiveText(
                widget.maintainanceModel.taxiPlateNumber!,
                style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: isMobile ? 10.sp : 12.sp),
              ),
            ] else if (widget.maintainanceModel.taxiRegistrationNumber != '') ...[
              ResponsiveText(
                "Taxi Reg. No. ",
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 10.sp : 12.sp,
                ),
              ),
              ResponsiveText(
                widget.maintainanceModel.taxiRegistrationNumber!,
                style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: isMobile ? 10.sp : 12.sp),
              ),
            ],
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResponsiveText(
              "Inspected By: ",
              style: AppTextStyles.bodyExtraSmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 10.sp : 12.sp,
              ),
            ),
            ResponsiveText(
              widget.maintainanceModel.inspectedBy,
              style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: isMobile ? 10.sp : 12.sp),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResponsiveText(
              "Assigned to: ",
              style: AppTextStyles.bodyExtraSmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 10.sp : 12.sp,
              ),
            ),
            ResponsiveText(
              widget.maintainanceModel.assignedTo == '' ? "Not assigned" : widget.maintainanceModel.assignedTo!,
              style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: isMobile ? 10.sp : 12.sp),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ResponsiveText(
                "Last Updated By: ",
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 10.sp : 12.sp,
                ),
              ),
            ),
            Flexible(
              child: ResponsiveText(
                widget.maintainanceModel.lastUpdatedBy,
                style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: isMobile ? 10.sp : 12.sp),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResponsiveText(
              "Last Updated At: ",
              style: AppTextStyles.bodyExtraSmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 10.sp : 12.sp,
              ),
            ),
            ResponsiveText(
              HelperFunctions.formatDate(
                widget.maintainanceModel.lastUpdatedAt,
                showTime: true,
              ),
              style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: isMobile ? 10.sp : 12.sp),
            ),
          ],
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      width: 400,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12.w : 16.w,
        vertical: isMobile ? 8.h : 12.h,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleSection,
                Spacing.vSmall,
                ResponsiveText(
                  HelperFunctions.timeDifferenceFromNow(widget.maintainanceModel.date),
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColors.subText,
                    fontSize: 10.sp,
                  ),
                ),
                Spacing.vSmall,
                ResponsiveText(
                  widget.maintainanceModel.description,
                  style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: 10.sp),
                ),
                Spacing.vMedium,
                ResponsiveText(
                  "Attachments",
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
                Spacing.vSmall,
                attachmentsRow,
                Spacing.vSmall,
                infoWrap,
                Spacing.vSmall,
                actionButtons,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleSection,
                          Spacing.vSmall,
                          ResponsiveText(
                            HelperFunctions.timeDifferenceFromNow(widget.maintainanceModel.date),
                            style: AppTextStyles.bodyExtraSmall.copyWith(
                              color: AppColors.subText,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actionButtons,
                  ],
                ),
                Spacing.vMedium,
                ResponsiveText(
                  widget.maintainanceModel.description,
                  style: AppTextStyles.bodyExtraSmall.copyWith(fontSize: 12.sp),
                ),
                Spacing.vLarge,
                ResponsiveText(
                  "Attachments",
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                Spacing.vSmall,
                attachmentsRow,
                Spacing.vSmall,
                infoWrap,
              ],
            ),
    );
  }
}
