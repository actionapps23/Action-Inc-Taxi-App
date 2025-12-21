import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/add_inventory_popup.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_outline_button.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_dropdown.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/inventory/inventory_cubit.dart';
import 'package:action_inc_taxi_app/cubit/inventory/inventory_state.dart';
import 'package:action_inc_taxi_app/features/inventory/inventory_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventorySceen extends StatefulWidget {
  const InventorySceen({super.key});

  @override
  State<InventorySceen> createState() => _InventorySceenState();
}

class _InventorySceenState extends State<InventorySceen> {
  String _selectedCategory = "engine";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryCubit>().loadInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final InventoryCubit inventoryCubit = context.watch<InventoryCubit>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Navbar(),
            Spacing.vLarge,
            BlocBuilder<InventoryCubit, InventoryState>(
              bloc: inventoryCubit,
              builder: (context, state) {
                if (state is InventoryLoading ||
                    state is InventoryAdding ||
                    state is InventoryInitial ||
                    state is InventoryUpdating) {
                  return SizedBox(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is InventoryError) {
                  return Center(
                    child: Text(
                      "Error loading inventory",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.only(left: 12.w, right: 12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Inventory",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Spacing.hLarge,
                              Column(
                                children: [
                                  SizedBox(
                                    width: 60.w,
                                    child: AppDropdown<String>(
                                      labelText: "Category",
                                      value: _selectedCategory,
                                      items: [
                                        DropdownMenuItem(
                                          value: "engine",
                                          child: Text(
                                            "Engine",
                                            style: AppTextStyles.bodyExtraSmall,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "brakes",
                                          child: Text(
                                            "Brakes",
                                            style: AppTextStyles.bodyExtraSmall,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "tires",
                                          child: Text(
                                            "Tires",
                                            style: AppTextStyles.bodyExtraSmall,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "interior",
                                          child: Text(
                                            "Interior",
                                            style: AppTextStyles.bodyExtraSmall,
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedCategory = value;
                                            inventoryCubit.filterByCategory(
                                              value,
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Spacing.hLarge,
                              Row(
                                children: [
                                  AppOutlineButton(
                                    borderColor: AppColors.scaffold,
                                    label: "Add New Item",
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AddInventoryPopup(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacing.vLarge,
                          InventoryTable(items: state.inventoryItems!),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            Spacing.vXXLarge,
          ],
        ),
      ),
    );
  }
}
