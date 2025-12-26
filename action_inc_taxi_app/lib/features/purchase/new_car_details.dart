import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/checklist_table.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/field/field_cubit.dart';
import 'package:action_inc_taxi_app/cubit/field/field_state.dart';
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

  @override
  void initState() {
    super.initState();
    fieldCubitForNewCarEquipment = FieldCubit(
      collectionName: AppConstants.newCarEquipmentCollection,
      documentId: AppConstants.newCarEquipmentCollection,
    );
    fieldCubitForLTFRB = FieldCubit(
      collectionName: AppConstants.lftrbCollectionForNewCar,
      documentId: AppConstants.lftrbCollectionForNewCar,
    );
    fieldCubitForLTO = FieldCubit(
      collectionName: AppConstants.ltoCollectionForNewCar,
      documentId: AppConstants.ltoCollectionForNewCar,
    );
    fieldCubitForNewCarEquipment.loadFieldEntries();
    fieldCubitForLTFRB.loadFieldEntries();
    fieldCubitForLTO.loadFieldEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<FieldCubit, FieldState>(
          bloc: fieldCubitForNewCarEquipment,
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Navbar(),
                if (state is! FieldEntriesLoaded ||
                    (state.entries.isEmpty)) ...[
                  Text("New Car Details", style: AppTextStyles.bodyExtraSmall),
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
        ),
      ),
    );
  }
}
