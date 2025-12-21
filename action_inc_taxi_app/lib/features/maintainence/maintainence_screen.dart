import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaintainenceScreen extends StatelessWidget {
  const MaintainenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MaintainanceCubit maintainanceCubit = context
        .read<MaintainanceCubit>();
    final List<MaintainanceModel> maintainanceItems =
        maintainanceCubit.state.maintainanceItems;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Navbar(),
            Spacing.vLarge,
            Center(
              child: Text(
                "Maintenance Request",
                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Spacing.vLarge,
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  itemCount: maintainanceItems.length,
                  separatorBuilder: (context, index) => Column(
                    children: [
                      Spacing.vLarge,
                      Divider(color: Colors.white12, height: 1),
                      Spacing.vLarge,
                    ],
                  ),
                  itemBuilder: (context, index) {
                    final maintainanceItem = maintainanceItems[index];
                    return MaintainanceItemCard(maintainanceModel: maintainanceItem);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Spacing.vSmall,
                    Text(
                      "7 hours ago", // Placeholder for time, replace with actual logic if needed
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
                  AppOutlineButton(label: "Solved", prefixIcon: Icon(Icons.done)),
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
          Text("Attachments", style: AppTextStyles.bodyExtraSmall.copyWith(fontWeight: FontWeight.w600)),
          Spacing.vSmall,
          Row(
            children: maintainanceModel.attachmentUrls.map((attachmentUrl) => Padding(
              padding: const EdgeInsets.only(right: 12.0),
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
                  child: Icon(Icons.image, color: Colors.blueAccent, size: 32),
                ),
              ),
            )).toList(),
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
                  Text("Taxi No. ", style: AppTextStyles.bodyExtraSmall.copyWith(fontWeight: FontWeight.w600)),
                  Text(maintainanceModel.taxiId, style: AppTextStyles.bodyExtraSmall),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Fleet No. ", style: AppTextStyles.bodyExtraSmall.copyWith(fontWeight: FontWeight.w600)),
                  Text(maintainanceModel.fleetId, style: AppTextStyles.bodyExtraSmall),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Inspected By: ", style: AppTextStyles.bodyExtraSmall.copyWith(fontWeight: FontWeight.w600)),
                  Text(maintainanceModel.inspectedBy, style: AppTextStyles.bodyExtraSmall),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Assigned to: ", style: AppTextStyles.bodyExtraSmall.copyWith(fontWeight: FontWeight.w600)),
                  Text(maintainanceModel.assignedTo ?? "Not assigned", style: AppTextStyles.bodyExtraSmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
