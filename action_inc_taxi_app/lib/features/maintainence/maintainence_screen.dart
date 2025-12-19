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
    final MaintainanceCubit maintainanceCubit = context.read<MaintainanceCubit>();
    final List<MaintainanceModel> maintainanceItems = maintainanceCubit.state.maintainanceItems; 

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
                style: AppTextStyles.bodySmall.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Spacing.vLarge,
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 32),
                itemCount: maintainanceItems.length,
                itemBuilder: (context, index) {
                  final maintainanceItem = maintainanceItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: MaintainanceItemCard(maintainanceModel: maintainanceItem),
                  );
                },
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacing.vSmall,
                    Text(
                      "7 hours ago", // Placeholder for time, replace with actual logic if needed
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Spacing.hLarge,
              Column(
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
            style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
          ),
          Spacing.vSmall,
          Text("Attachments", style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          Spacing.vSmall,
          Row(
            children: maintainanceModel.attachmentUrls.map((attachmentUrl) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
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
          Row(
            children: [
              Text("Taxi No. ", style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              Text("${maintainanceModel.taxiId}", style: AppTextStyles.bodySmall),
              Spacing.hLarge,
              Text("Fleet No. ", style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              Text("${maintainanceModel.fleetId}", style: AppTextStyles.bodySmall),
              Spacing.hLarge,
              Text("Inspected By: ", style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              Text(maintainanceModel.inspectedBy, style: AppTextStyles.bodySmall),
              Spacing.hLarge,
              Text("Assigned to: ", style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              Text(maintainanceModel.assignedTo, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}