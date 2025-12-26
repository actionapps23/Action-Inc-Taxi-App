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
    controller.text =
        '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
  }

  return pickedDate;
}
