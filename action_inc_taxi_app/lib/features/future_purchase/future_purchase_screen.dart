import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/widgets/checklist_table.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/cubit/future_purchase/future_purchase_cubit.dart';
import 'package:action_inc_taxi_app/cubit/future_purchase/future_purchase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuturePurchaseScreen extends StatefulWidget {
  const FuturePurchaseScreen({super.key});

  @override
  State<FuturePurchaseScreen> createState() => _FuturePurchaseScreenState();
}

class _FuturePurchaseScreenState extends State<FuturePurchaseScreen> {
  late final FuturePurchaseCubit futurePurchaseCubit;

  @override
  void initState() {
    super.initState();
    futurePurchaseCubit = context.read<FuturePurchaseCubit>();
    futurePurchaseCubit.loadFieldEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FuturePurchaseCubit, FuturePurchaseState>(
        bloc: futurePurchaseCubit,
        builder: (context, state) {
          return Column(
            children: [
              Navbar(),
              if (state is FuturePurchaseLoading ||
                  state is FuturePurchaseInitial ||
                  state is FuturePurchaseEntryUpdating ||
                  state is FuturePurchaseEntryDeleting ||
                  state is FuturePurchaseEntryAdding)
                const Center(child: CircularProgressIndicator())
              else if (state is FuturePurchaseEntriesLoaded)
                Expanded(
                  child: ChecklistTable(
                    title: 'Future Purchase Checklist',
                    isFromFutureCarPurchase: true,
                    futurePurchaseCubit: futurePurchaseCubit,
                  ),
                )
              else if (state is FuturePurchaseError ||
                  state is FuturePurchaseEntryUpdateError ||
                  state is FuturePurchaseEntryDeleteError ||
                  state is FuturePurchaseEntryAddError)
                Center(child: Text(AppConstants.genericErrorMessage)),
            ],
          );
        },
      ),
    );
  }
}
