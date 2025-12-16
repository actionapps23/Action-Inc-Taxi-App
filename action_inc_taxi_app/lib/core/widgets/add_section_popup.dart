import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/action_buttons.dart';
import 'package:flutter/material.dart';

class AddSectionPopup extends StatelessWidget {
  const AddSectionPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Add New Section"),
        Expanded(
          child: Column(
            children: [
              Text("Add Section Name"),
              AppTextFormField(hintText: "Section Name"),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text("Add Section Details"),
              AppTextFormField(hintText: "Section Details"),
            ],
          ),
        ),
        ActionButtons(
          onSubmit: () {
            SnackBarHelper.showSuccessSnackBar(
              context,
              "Section added Successfully",
            );
          },
          onCancel: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
