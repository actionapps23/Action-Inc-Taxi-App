import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerDialog(
  BuildContext context,
  TextEditingController controller,
) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    initialDate: DateTime.now(),
  );

  if (pickedDate != null) {
    controller.text = HelperFunctions.formatDate(pickedDate);
  }

  return pickedDate;
}
