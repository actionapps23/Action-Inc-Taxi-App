import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/inventory_item_model.dart';
import 'package:action_inc_taxi_app/core/models/inventory_section_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_dropdown.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/inventory_field_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/status_chip.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/inventory/inventory_cubit.dart';
import 'package:action_inc_taxi_app/cubit/inventory/inventory_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/utils/device_utils.dart';

class AddInventoryPopup extends StatefulWidget {
  final InventoryItemModel? item;
  bool isEditMode() => item != null;
  const AddInventoryPopup({super.key, this.item});

  @override
  State<AddInventoryPopup> createState() => _AddInventoryPopupState();
}

class _AddInventoryPopupState extends State<AddInventoryPopup> {
  String _selectedCategory = "engine";
  String _selectedStatus = "inStock";
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _totalAvailableController =
      TextEditingController();
  final TextEditingController _totalNeededController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode()) {
      _fieldNameController.text = widget.item!.name;
      _totalAvailableController.text = widget.item!.totalAvailable.toString();
      _totalNeededController.text = widget.item!.totalNeeded.toString();
      _selectedStatus = HelperFunctions.stringFromInventoryStatus(
        widget.item!.stockStatus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final InventoryCubit inventoryCubit = context.read<InventoryCubit>();
    return BlocBuilder<InventoryCubit, InventoryState>(
      bloc: inventoryCubit,
      builder: (context, state) {
        final device = DeviceUtils(context);
        double popupWidth;
        EdgeInsets popupPadding;
        final screenWidth = MediaQuery.of(context).size.width;

        if (device.isExtraSmallMobile) {
          popupWidth = screenWidth * 0.98;
          popupPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16);
        } else if (device.isSmallMobile) {
          popupWidth = screenWidth * 0.95;
          popupPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24);
        } else if (device.isMediumMobile) {
          popupWidth = screenWidth * 0.85;
          popupPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 28);
        } else if (device.isTablet) {
          popupWidth = screenWidth * 0.7;
          popupPadding = const EdgeInsets.all(32);
        } else if (device.isLargeTablet) {
          popupWidth = screenWidth * 0.5;
          popupPadding = const EdgeInsets.all(40);
        } else {
          popupWidth = screenWidth * 0.35;
          popupPadding = const EdgeInsets.all(48);
        }

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: popupWidth,
              padding: popupPadding,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                  // ...existing code...
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacing.vMedium,
                      !widget.isEditMode()
                          ? InventoryField(
                              label: "Select Type",
                              child: AppDropdown(
                                value: "engine_fuel",
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: "engine_fuel",
                                    child: ResponsiveText(
                                      "Engine & Fuel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "suspension_steering",
                                    child: ResponsiveText(
                                      "Suspension & Steering",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "electrical",
                                    child: ResponsiveText(
                                      "Electrical & Electronics",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "cooling_hvac",
                                    child: ResponsiveText(
                                      "Cooling & HVAC",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "transmission_lubricants",
                                    child: ResponsiveText(
                                      "Transmission & Lubricants",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "brakes",
                                    child: ResponsiveText(
                                      "Brakes",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "exterior",
                                    child: ResponsiveText(
                                      "Exterior / Accessories",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "wheels_tires",
                                    child: ResponsiveText(
                                      "Wheels & Tires",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      Spacing.vLarge,
                      InventoryField(
                        label: !widget.isEditMode()
                            ? "Enter field Name"
                            : "Update field Name",
                        child: AppTextFormField(
                          hintText: "Engine Oil",
                          controller: _fieldNameController,
                        ),
                      ),
                      Spacing.vLarge,
                      InventoryField(
                        label: !widget.isEditMode()
                            ? "Enter Total We have"
                            : "Update Total We have",
                        child: AppTextFormField(
                          hintText: "110 Litre",
                          controller: _totalAvailableController,
                        ),
                      ),
                      Spacing.vLarge,
                      InventoryField(
                        label: !widget.isEditMode()
                            ? "Enter Total We need"
                            : "Update Total We need",
                        child: AppTextFormField(
                          hintText: "0 Litre",
                          controller: _totalNeededController,
                        ),
                      ),
                      Spacing.vLarge,
                      InventoryField(
                        label: !widget.isEditMode()
                            ? "Change Status"
                            : "Update Status",
                        child: AppDropdown(
                          value: "inStock",
                          onChanged: (value) {
                            _selectedStatus = value!;
                          },
                          items: [
                            DropdownMenuItem(
                              value: "inStock",
                              child: StatusChip(
                                label: "In Stock",
                                color: AppColors.primary,
                              ),
                            ),
                            DropdownMenuItem(
                              value: "outOfStock",
                              child: StatusChip(
                                label: "Out of Stock",
                                color: AppColors.error,
                              ),
                            ),
                            DropdownMenuItem(
                              value: "ordered",
                              child: StatusChip(
                                label: "Ordered",
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacing.vExtraLarge,
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            InventorySectionModel
                            inventorySectionModel = InventorySectionModel(
                              name: _selectedCategory,
                              items: [
                                InventoryItemModel(
                                  name: _fieldNameController.text,
                                  totalAvailable: int.parse(
                                    _totalAvailableController.text,
                                  ),
                                  totalNeeded: int.parse(
                                    _totalNeededController.text,
                                  ),
                                  stockStatus:
                                      HelperFunctions.inventoryStatusFromString(
                                        _selectedStatus,
                                      ),
                                ),
                              ],
                            );
                            widget.isEditMode()
                                ? inventoryCubit.updateInventoryItem(
                                    inventorySectionModel,
                                    widget.item!.name,
                                  )
                                : inventoryCubit.addFiledsToCategory(
                                    inventorySectionModel,
                                  );
                            Navigator.of(context).pop();
                          },
                          child: ResponsiveText(
                            state is InventoryAdding
                                ? "Adding..."
                                : state is InventoryUpdating
                                ? "Updating..."
                                : widget.isEditMode()
                                ? "Update"
                                : "Add",
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.buttonText,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
