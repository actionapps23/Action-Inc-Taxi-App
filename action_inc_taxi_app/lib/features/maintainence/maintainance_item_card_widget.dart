import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
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
  bool _isSolved = false;

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final LoginSuccess loginState = loginCubit.state as LoginSuccess;
    final bool isAdmin = loginState.user.isAdmin;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.maintainanceModel.title,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_isSolved ? 'Solved' : 'Unsolved'),
                          backgroundColor: _isSolved
                              ? AppColors.success
                              : AppColors.error,
                          labelStyle: AppTextStyles.bodyExtraSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Spacing.vSmall,
                    Text(
                      HelperFunctions.timeDifferenceFromNow(
                        widget.maintainanceModel.date,
                      ),
                      style: AppTextStyles.bodyExtraSmall,
                    ),
                  ],
                ),
              ),
              Spacing.hLarge,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isAdmin)
                    AppOutlineButton(
                      label: "Edit",

                      prefixIcon: Icon(Icons.edit),
                      onPressed: () {
                        // TODO: wire edit action
                      },
                    ),
                  Spacing.hSmall,
                  AppButton(
                    width: 32.w,
                    text: _isSolved ? 'Mark as Unsolved' : 'Mark as Solved',
                    backgroundColor: _isSolved
                        ? AppColors.error
                        : AppColors.success,
                    textColor: _isSolved ? Colors.white : AppColors.buttonText,
                    onPressed: () {
                      setState(() {
                        _isSolved = !_isSolved;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Spacing.vSmall,
          Text(
            widget.maintainanceModel.description,
            style: AppTextStyles.bodyExtraSmall,
          ),
          Spacing.vLarge,
          Text(
            "Attachments",
            style: AppTextStyles.bodyExtraSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.vSmall,
          Row(
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
                                    width:
                                        0.9.w *
                                        MediaQuery.of(context).size.width,
                                    height:
                                        0.7.h *
                                        MediaQuery.of(context).size.height,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width:
                                                  0.9.w *
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                              height:
                                                  0.7.h *
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height,
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
          Spacing.vSmall,
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Taxi No. ",
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.maintainanceModel.taxiId,
                    style: AppTextStyles.bodyExtraSmall,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Fleet No. ",
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.maintainanceModel.fleetId,
                    style: AppTextStyles.bodyExtraSmall,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Inspected By: ",
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.maintainanceModel.inspectedBy,
                    style: AppTextStyles.bodyExtraSmall,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Assigned to: ",
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.maintainanceModel.assignedTo ?? "Not assigned",
                    style: AppTextStyles.bodyExtraSmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
