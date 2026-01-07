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

class NewCarDetails extends StatefulWidget {
  const NewCarDetails({super.key});

  @override
  State<NewCarDetails> createState() => _NewCarDetailsState();
}

class _NewCarDetailsState extends State<NewCarDetails> {
  late final FieldCubit fieldCubitForNewCarEquipment;
  late final FieldCubit fieldCubitForLTFRB;
  late final FieldCubit fieldCubitForLTO;
  late final PurchaseCubit purchaseCubit;
  late final SelectionCubit selectionCubit;

  @override
  void initState() {
    super.initState();
    purchaseCubit = context.read<PurchaseCubit>();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<FieldCubit, FieldState>(
          bloc: fieldCubitForNewCarEquipment,
          builder: (context, fieldState) {
            return BlocBuilder<PurchaseCubit, PurchaseState>(
              bloc: purchaseCubit,
              builder: (context, purchaseState) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Navbar(),
                    if (fieldState is! FieldEntriesLoaded ||
                        (fieldState.entries.isEmpty)) ...[
                      Text(
                        "New Car Details",
                        style: AppTextStyles.bodyExtraSmall,
                      ),
                    ],
                    if (fieldState is FieldLoading ||
                        fieldState is FieldInitial ||
                        purchaseState is PurchaseLoading ||
                        purchaseState is PurchaseInitial || 
                        (purchaseState is AllDataLoaded && (purchaseState.newCarEquipmentData.isEmpty || purchaseState.ltfrbData.isEmpty || purchaseState.ltoData.isEmpty))) ...[
                      Spacing.vMedium,
                      Center(child: CircularProgressIndicator()),
                    ] else if (fieldState is FieldError) ...[
                      Spacing.vMedium,
                      Center(child: Text("Error: ${fieldState.message}")),
                    ] else if (purchaseState is PurchaseError ||
                        fieldState is FieldError) ...[
                      Spacing.vMedium,
                      Text(
                        "Error: ${purchaseState is PurchaseError
                            ? purchaseState.message
                            : fieldState is FieldError
                            ? fieldState.message
                            : ''}",
                      ),
                    ] else if (fieldState is FieldEntriesLoaded &&
                        fieldState.entries.isEmpty) ...[
                      Spacing.vMedium,
                      Center(child: Text("No entries found.")),
                    ] else if (purchaseState is AllDataLoaded && purchaseState.newCarEquipmentData.isNotEmpty && purchaseState.ltfrbData.isNotEmpty && purchaseState.ltoData.isNotEmpty) ...[
                      ChecklistTable(
                        title: "New Car equipments",
                        fieldCubit: fieldCubitForNewCarEquipment,
                      ),
                      Spacing.vLarge,
                      ChecklistTable(
                        title: "LTFRB Process (Franchise Compliance)",
                        fieldCubit: fieldCubitForLTFRB,
                      ),
                      Spacing.vLarge,
                      ChecklistTable(
                        title: "LTO Process",
                        fieldCubit: fieldCubitForLTO,
                      ),
                      Spacing.vLarge,
                    ],
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void loadData() async {
    final purchaseState = purchaseCubit.state;
    final selectionCubit = context.read<SelectionCubit>();
    fieldCubitForNewCarEquipment = FieldCubit(
      collectionName: AppConstants.newCarEquipmentChecklistCollection,
      documentId: AppConstants.newCarEquipmentChecklistCollection,
    );
    fieldCubitForLTFRB = FieldCubit(
      collectionName: AppConstants.lftrbChecklistCollectionForNewCar,
      documentId: AppConstants.lftrbChecklistCollectionForNewCar,
    );
    fieldCubitForLTO = FieldCubit(
      collectionName: AppConstants.ltoChecklistCollectionForNewCar,
      documentId: AppConstants.ltoChecklistCollectionForNewCar,
    );
    await fieldCubitForNewCarEquipment.loadFieldEntries();
    await fieldCubitForLTFRB.loadFieldEntries();
    await fieldCubitForLTO.loadFieldEntries();
    await purchaseCubit.getAllChecklists(selectionCubit.state.taxiPlateNo);

    if(purchaseState is AllDataLoaded){
      if(purchaseState.newCarEquipmentData.isEmpty || 
         purchaseState.ltfrbData.isEmpty || 
         purchaseState.ltoData.isEmpty){
        await purchaseCubit.saveAllChecklists(
          selectionCubit.state.taxiPlateNo,
          purchaseState.newCarEquipmentData,
          purchaseState.ltfrbData,
          purchaseState.ltoData,
        );
      }
    }
  }
}
