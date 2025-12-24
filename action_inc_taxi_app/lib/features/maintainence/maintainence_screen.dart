import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_cubit.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_state.dart';
import 'package:action_inc_taxi_app/features/maintainence/maintainance_item_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaintainenceScreen extends StatefulWidget {
  const MaintainenceScreen({super.key});

  @override
  State<MaintainenceScreen> createState() => _MaintainenceScreenState();
}

class _MaintainenceScreenState extends State<MaintainenceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaintainanceCubit>().fetchMaintainanceItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MaintainanceCubit maintainanceCubit = context.read<MaintainanceCubit>();

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
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacing.vLarge,
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: BlocBuilder<MaintainanceCubit, MaintainanceState>(
                  builder: (context, state) {
                    if (state is MaintainanceLoading ||
                        state is MaintainanceInitial) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is MaintainanceEmpty) {
                      return Center(
                        child: Text(
                          AppConstants.maintainanceEmptyMessage,
                          style: AppTextStyles.bodySmall,
                        ),
                      );
                    } else if (state is MaintainanceError) {
                      return Center(
                        child: Text(
                          AppConstants.maintainanceLoadError,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                        if (state is MaintainanceLoaded) {
                          final items = state.maintainanceItems;
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            itemCount: items.length,
                            separatorBuilder: (context, index) => Column(
                              children: [
                                Spacing.vLarge,
                                Divider(color: Colors.white12, height: 1),
                                Spacing.vLarge,
                              ],
                            ),
                            itemBuilder: (context, index) {
                              final maintainanceItem = items[index];
                              return MaintainanceItemCard(
                                maintainanceModel: maintainanceItem,
                              );
                            },
                          );
                        }
                        // fallback
                        return Center(child: CircularProgressIndicator());
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
