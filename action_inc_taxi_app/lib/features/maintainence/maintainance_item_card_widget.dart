import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintainanceItemCard extends StatelessWidget {
  final MaintainanceModel maintainanceModel;
  const MaintainanceItemCard({super.key, required this.maintainanceModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181917),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
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
                    Text(
                      maintainanceModel.title,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.vSmall,
                    Text(
                      HelperFunctions.timeDifferenceFromNow(maintainanceModel.date),
                      style: AppTextStyles.bodyExtraSmall,
                    ),
                  ],
                ),
              ),
              Spacing.hLarge,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppOutlineButton(label: "Edit", prefixIcon: Icon(Icons.edit)),
                  Spacing.vSmall,
                  AppOutlineButton(
                    label: "Solved",
                    prefixIcon: Icon(Icons.done),
                  ),
                ],
              ),
            ],
          ),
          Spacing.vSmall,
          Text(
            maintainanceModel.description,
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
            children: maintainanceModel.attachmentUrls!
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
                    maintainanceModel.taxiId,
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
                    maintainanceModel.fleetId,
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
                    maintainanceModel.inspectedBy,
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
                    maintainanceModel.assignedTo ?? "Not assigned",
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
