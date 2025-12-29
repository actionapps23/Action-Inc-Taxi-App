import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/checklist_table.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/field/field_cubit.dart';
import 'package:action_inc_taxi_app/cubit/field/field_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  late final FieldCubit fieldCubit;
  @override
  void initState() {
    super.initState();
    fieldCubit = FieldCubit(
      collectionName: AppConstants.purchaseCollection,
      documentId: AppConstants.purchaseCollection,
    );
    fieldCubit.loadFieldEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(),
          Spacing.vMedium,

          BlocBuilder<FieldCubit, FieldState>(
            bloc: fieldCubit,
            builder: (context, state) {
              if (state is FieldLoading || state is FieldInitial) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Purchase Of Car",
                      style: AppTextStyles.bodyExtraSmall,
                    ),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (state is FieldError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Purchase Of Car",
                      style: AppTextStyles.bodyExtraSmall,
                    ),
                    Center(child: Text("Error: ${state.message}")),
                  ],
                );
              } else if (state is FieldEntriesLoaded && state.entries.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Purchase Of Car",
                          style: AppTextStyles.bodyExtraSmall,
                        ),
                      ],
                    ),
                    Center(child: Text("No entries found.")),
                  ],
                );
              }
              return ChecklistTable(
                title: "Purchase Of Car",
                fieldCubit: fieldCubit,
              );
            },
          ),
        ],
      ),
    );
  }
}
