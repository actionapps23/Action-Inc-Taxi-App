import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/checklist_table.dart';
import 'package:action_inc_taxi_app/core/widgets/entry_field_popup.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/field/field_cubit.dart';
import 'package:action_inc_taxi_app/cubit/field/field_state.dart';
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

  @override
  void initState() {
    super.initState();
    fieldCubitForLTFRB = FieldCubit(
      collectionName: AppConstants.lftrbForFranchiseTransferCollection,
      documentId: AppConstants.lftrbForFranchiseTransferCollection,
    );
    fieldCubitForPNP = FieldCubit(
      collectionName: AppConstants.pnpForFranchiseTransferCollection,
      documentId: AppConstants.pnpForFranchiseTransferCollection,
    );
    fieldCubitForLTO = FieldCubit(
      collectionName: AppConstants.ltoForFranchiseTransferCollection,
      documentId: AppConstants.ltoForFranchiseTransferCollection,
    );
    fieldCubitForLTFRB.loadFieldEntries();
    fieldCubitForPNP.loadFieldEntries();
    fieldCubitForLTO.loadFieldEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(),
          BlocBuilder(
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
                        Text(
                          "Franchise Transfer",
                          style: AppTextStyles.bodyExtraSmall,
                        ),
                        AppOutlineButton(
                          label: "Add new Field",
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EntryFieldPopup(
                                fieldCubit: fieldCubitForLTFRB,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                  if (state is FieldLoading || state is FieldInitial) ...[
                    Spacing.vMedium,
                    Center(child: CircularProgressIndicator()),
                  ] else if (state is FieldError) ...[
                    Spacing.vMedium,
                    Center(child: Text("Error: ${state.message}")),
                  ] else if (state is FieldError) ...[
                    Spacing.vMedium,
                    Text("Error: ${state.message}"),
                  ] else if (state is FieldEntriesLoaded &&
                      state.entries.isEmpty) ...[
                    Spacing.vMedium,
                    Center(child: Text("No entries found.")),
                  ] else ...[
                    ChecklistTable(
                      title: "LTFRB Process (Franchise Transfer)",
                      fieldCubit: fieldCubitForLTFRB,
                    ),
                    ChecklistTable(
                      title: "PNP Process (Franchise Transfer)",
                      fieldCubit: fieldCubitForPNP,
                    ),
                    ChecklistTable(
                      title: "LTO Process (Franchise Transfer)",
                      fieldCubit: fieldCubitForLTO,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
