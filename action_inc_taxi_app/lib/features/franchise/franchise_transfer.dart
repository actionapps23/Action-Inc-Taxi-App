import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/checklist_table.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/field/field_cubit.dart';
import 'package:action_inc_taxi_app/cubit/field/field_state.dart';
import 'package:action_inc_taxi_app/cubit/franchise_transfer/farnchise_transfer_state.dart';
import 'package:action_inc_taxi_app/cubit/franchise_transfer/franchise_transfer_cubit.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FranchiseTransfer extends StatefulWidget {
  const FranchiseTransfer({super.key});

  @override
  State<FranchiseTransfer> createState() => _FranchiseTransferState();
}

class _FranchiseTransferState extends State<FranchiseTransfer> {
  late final FieldCubit fieldCubitForLTFRB;
  late final FieldCubit fieldCubitForPNP;
  late final FieldCubit fieldCubitForLTO;
  late final FranchiseTransferCubit franchiseTransferCubit;
  late final SelectionCubit selectionCubit;

  @override
  void initState() {
    super.initState();
    franchiseTransferCubit = context.read<FranchiseTransferCubit>();
    selectionCubit = context.read<SelectionCubit>();
    fieldCubitForLTFRB = FieldCubit(
      collectionName: AppConstants.lftrbChecklistForFranchiseTransferCollection,
      documentId: AppConstants.lftrbChecklistForFranchiseTransferCollection,
    );
    fieldCubitForPNP = FieldCubit(
      collectionName: AppConstants.pnpChecklistForFranchiseTransferCollection,
      documentId: AppConstants.pnpChecklistForFranchiseTransferCollection,
    );
    fieldCubitForLTO = FieldCubit(
      collectionName: AppConstants.ltoChecklistForFranchiseTransferCollection,
      documentId: AppConstants.ltoChecklistForFranchiseTransferCollection,
    );
    _initializeChecklists();
  }

  Future<void> _initializeChecklists() async {
    await fieldCubitForPNP.loadFieldEntries();
    await fieldCubitForLTO.loadFieldEntries();
    await fieldCubitForLTFRB.loadFieldEntries();
    await franchiseTransferCubit.getAllChecklists(
      selectionCubit.state.taxiPlateNo,
    );

    final fieldStateForPNP = fieldCubitForPNP.state;
    final fieldStateForLTFRB = fieldCubitForLTFRB.state;
    final fieldStateForLTO = fieldCubitForLTO.state;
    final franchiseState = franchiseTransferCubit.state;

    final allDataLoaded =
        franchiseState is AllDataLoaded &&
        fieldStateForPNP is FieldEntriesLoaded &&
        fieldStateForLTFRB is FieldEntriesLoaded &&
        fieldStateForLTO is FieldEntriesLoaded;

    final needsToSaveChecklists =
        allDataLoaded &&
        (fieldStateForPNP.entries.length != franchiseState.pnpData.length ||
            fieldStateForLTFRB.entries.length !=
                franchiseState.ltfrbData.length ||
            fieldStateForLTO.entries.length != franchiseState.ltoData.length);

    if (needsToSaveChecklists) {
      await franchiseTransferCubit.saveAllChecklists(
        selectionCubit.state.taxiPlateNo,
        fieldStateForPNP.entries,
        fieldStateForLTFRB.entries,
        fieldStateForLTO.entries,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Navbar(),
            BlocBuilder<FranchiseTransferCubit, FranchiseTransferState>(
              bloc: franchiseTransferCubit,
              builder: (context, franchiseTransferState) {
                return BlocListener<FieldCubit, FieldState>(
                  bloc: fieldCubitForLTFRB,
                  listener: (context, state) {
                    if (state is FieldEntryAdded) {
                      SnackBarHelper.showSuccessSnackBar(
                        context,
                        "Field entry added successfully.",
                      );
                    } else if (state is FieldEntryUpdated) {
                      SnackBarHelper.showSuccessSnackBar(
                        context,
                        "Field entry updated successfully.",
                      );
                    } else if (state is FieldEntryDeleted) {
                      SnackBarHelper.showSuccessSnackBar(
                        context,
                        "Field entry deleted successfully.",
                      );
                    }
                  },
                  child: BlocBuilder(
                    bloc: fieldCubitForLTFRB,
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (state is! FieldEntriesLoaded ||
                              (state.entries.isEmpty)) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ResponsiveText(
                                    "Franchise Transfer",
                                    style: AppTextStyles.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // AppOutlineButton(
                                //   label: "Add new Field",
                                //   onPressed: () {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) => EntryFieldPopup(
                                //         fieldCubit: fieldCubitForLTFRB,
                                //       ),
                                //     );
                                //   },
                                // ),
                              ],
                            ),
                          ],
                          if (state is FieldLoading ||
                              state is FieldInitial ||
                              state is FieldEntryAdding ||
                              state is FieldEntryDeleting ||
                              state is FieldEntryUpdating ||
                              franchiseTransferState
                                  is FranchiseTransferLoading) ...[
                            Spacing.vMedium,
                            Center(child: CircularProgressIndicator()),
                          ] else if (state is FieldError) ...[
                            Spacing.vMedium,
                            Center(
                              child: ResponsiveText("Error: ${state.message}"),
                            ),
                          ] else if (state is FieldError) ...[
                            Spacing.vMedium,
                            ResponsiveText("Error: ${state.message}"),
                          ] else if (franchiseTransferState
                              is AllDataLoaded) ...[
                            ChecklistTable(
                              title: "LTFRB Process (Franchise Transfer)",
                              fieldCubit: fieldCubitForLTFRB,
                              data: franchiseTransferState.ltfrbData,
                              onEdit: (updatedItem) {
                                franchiseTransferCubit
                                    .updateFranchiseTransferRecord(
                                      selectionCubit.state.taxiPlateNo,
                                      updatedItem,
                                      AppConstants
                                          .lftrbRecordForFranchiseTransferCollection,
                                    );
                              },
                            ),
                            ChecklistTable(
                              title: "PNP Process (Franchise Transfer)",
                              fieldCubit: fieldCubitForPNP,
                              data: franchiseTransferState.pnpData,
                              onEdit: (updatedItem) {
                                franchiseTransferCubit
                                    .updateFranchiseTransferRecord(
                                      selectionCubit.state.taxiPlateNo,
                                      updatedItem,
                                      AppConstants
                                          .pnpRecordForFranchiseTransferCollection,
                                    );
                              },
                            ),
                            ChecklistTable(
                              title: "LTO Process (Franchise Transfer)",
                              fieldCubit: fieldCubitForLTO,
                              data: franchiseTransferState.ltoData,
                              onEdit: (updatedItem) {
                                franchiseTransferCubit
                                    .updateFranchiseTransferRecord(
                                      selectionCubit.state.taxiPlateNo,
                                      updatedItem,
                                      AppConstants
                                          .ltoRecordForFranchiseTransferCollection,
                                    );
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
