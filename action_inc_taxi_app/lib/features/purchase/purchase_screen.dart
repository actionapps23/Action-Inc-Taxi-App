import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/checklist_table.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/field/field_cubit.dart';
import 'package:action_inc_taxi_app/cubit/field/field_state.dart';
import 'package:action_inc_taxi_app/cubit/purchase/purchase_cubit.dart';
import 'package:action_inc_taxi_app/cubit/purchase/purchase_state.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  late final FieldCubit fieldCubit;
  late final SelectionCubit selectionCubit;
  late final PurchaseCubit purchaseCubit;
  @override
  void initState() {
    super.initState();
    selectionCubit = context.read<SelectionCubit>();
    purchaseCubit = context.read<PurchaseCubit>();
    fieldCubit = FieldCubit(
      collectionName: AppConstants.purchaseChecklistCollection,
      documentId: AppConstants.purchaseChecklistCollection,
    );
    // funcion to fetch data
    fetchData();
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
            builder: (context, fiedState) {
              return BlocBuilder<PurchaseCubit, PurchaseState>(
                bloc: purchaseCubit,
                builder: (context, purchaseState) {
                  if (purchaseState is PurchaseLoading || purchaseState is PurchaseInitial) {
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
                  } else if (fiedState is FieldError || purchaseState is PurchaseError) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Purchase Of Car",
                          style: AppTextStyles.bodyExtraSmall,
                        ),
                        Center(
                          child: Text(
                            "Error: ${AppConstants.genericErrorMessage}",
                          ),
                        ),
                      ],
                    );
                  }
                  return ChecklistTable(
                    title: "Purchase Of Car",
                    fieldCubit: fieldCubit,
                    data: (purchaseState as PurchaseLoaded).purchaseData,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void fetchData() async {
    try {
      await fieldCubit.loadFieldEntries();
      await purchaseCubit.getPurchaseRecord(selectionCubit.state.taxiPlateNo);
      if (purchaseCubit.state is PurchaseLoaded) {
        final state = purchaseCubit.state as PurchaseLoaded;
        if (state.purchaseData.isEmpty &&
            fieldCubit.state is FieldEntriesLoaded) {
          await purchaseCubit.savePurchaseRecord(
            selectionCubit.state.taxiPlateNo,
            (fieldCubit.state as FieldEntriesLoaded).entries,
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching purchase data: $e");
    }
  }
}
