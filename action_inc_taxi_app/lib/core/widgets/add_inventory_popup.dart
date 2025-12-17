import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_dropdown.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class AddSectionPopup extends StatelessWidget {
  const AddSectionPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("Select Category to Add Section")),
              Expanded(
                flex: 2,
                child: AppDropdown(
                  items: [
                    DropdownMenuItem(value: "engine", child: Text("Engine")),
                    DropdownMenuItem(
                      value: "interior",
                      child: Text("Interior"),
                    ),
                    DropdownMenuItem(value: "tires", child: Text("Tires")),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(child: Text("Enter total we have")),
              Expanded(
                flex: 2,
                child: AppTextFormField(hintText: "Total Available"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("Enter total we needed")),
              Expanded(
                flex: 2,
                child: AppTextFormField(hintText: "Total Needed"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("Stock Status")),
              Expanded(
                flex: 2,
                child: AppDropdown(
                  items: [
                    DropdownMenuItem(
                      value: "in_stock",
                      child: StatusChip(
                        label: "In Stock",
                        color: AppColors.primary,
                      ),
                    ),
                    DropdownMenuItem(
                      value: "out_of_stock",
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
            ],
          ),
        ],
      ),
    );
  }
}
