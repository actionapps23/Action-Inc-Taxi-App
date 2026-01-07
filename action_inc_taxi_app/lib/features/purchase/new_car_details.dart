import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/checklist_table.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
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
    _initializeChecklists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<FieldCubit, FieldState>(
          bloc: fieldCubitForLTO,
          builder: (context , fieldStateForLTO) {
            return BlocBuilder<FieldCubit, FieldState>(
              bloc: fieldCubitForLTFRB,
              builder: (context, fieldStateForLTFRB) {
                return BlocBuilder<FieldCubit, FieldState>(
                  bloc: fieldCubitForNewCarEquipment,
                  builder: (context, fieldState) {
                    return BlocBuilder<PurchaseCubit, PurchaseState>(
                      bloc: purchaseCubit,
                      builder: (context, purchaseState) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Navbar(),
                            _buildHeader(fieldState),
                            _buildBody([fieldCubitForLTFRB, fieldCubitForLTO, fieldCubitForNewCarEquipment], purchaseState),
                          ],
                        );
                      },
                    );
                  },
                );
              }
            );
          }
        ),
      ),
    );
  }

  Widget _buildHeader(FieldState fieldState) {
    if (fieldState is! FieldEntriesLoaded || (fieldState.entries.isEmpty)) {
      return ResponsiveText(
        "New Car Details",
        style: AppTextStyles.bodyExtraSmall,
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildBody(List<FieldCubit> fieldCubits, PurchaseState purchaseState) {
    if (_isLoading(fieldCubits, purchaseState)) {
      return Column(
        children: [
          Spacing.vMedium,
          Center(child: CircularProgressIndicator()),
        ],
      );
    }
    if (fieldCubits.any((fieldCubit) => fieldCubit.state is FieldError)) {
      final errorFieldCubit = fieldCubits.firstWhere((fieldCubit) => fieldCubit.state is FieldError);
      return _buildError((errorFieldCubit.state as FieldError).message);
    }
    if (purchaseState is PurchaseError) {
      return _buildError(purchaseState.message);
    }
    // if (fieldState is FieldEntriesLoaded && fieldState.entries.isEmpty) {
    //   return Column(
    //     children: [
    //       Spacing.vMedium,
    //       Center(child: ResponsiveText("No entries found.")),
    //     ],
    //   );
    // }
    if (purchaseState is AllDataLoaded) {
      return Column(
        children: [
          ChecklistTable(
            title: "New Car equipments",
            fieldCubit: fieldCubitForNewCarEquipment,
            data: purchaseState.newCarEquipmentData,
          ),
          Spacing.vLarge,
          ChecklistTable(
            title: "LTFRB Process (Franchise Compliance)",
            fieldCubit: fieldCubitForLTFRB,
            data: purchaseState.ltfrbData,
          ),
          Spacing.vLarge,
          ChecklistTable(
            title: "LTO Process",
            fieldCubit: fieldCubitForLTO,
            data: purchaseState.ltoData,
          ),
          Spacing.vLarge,
        ],
      );
    }
    return SizedBox.shrink();
  }

  bool _isLoading(List<FieldCubit> fieldCubits, PurchaseState purchaseState) {
    return fieldCubits.any((fieldCubit) =>
            fieldCubit.state is FieldLoading ||
            fieldCubit.state is FieldInitial) ||
        purchaseState is PurchaseLoading ||
        purchaseState is PurchaseInitial;
  }

  Widget _buildError(String? message) {
    return Column(
      children: [
        Spacing.vMedium,
        Center(child: ResponsiveText("Error: ${message ?? ''}")),
      ],
    );
  }
  Future<void> _initializeChecklists() async {
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
    final purchaseState = purchaseCubit.state;

    if (purchaseState is AllDataLoaded) {
      if (purchaseState.newCarEquipmentData.isEmpty ||
          purchaseState.ltfrbData.isEmpty ||
          purchaseState.ltoData.isEmpty) {
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
