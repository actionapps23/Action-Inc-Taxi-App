import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:action_inc_taxi_app/core/widgets/checklist_table.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:flutter/material.dart';

class PurchaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(),
          Spacing.vMedium,
          ChecklistTable(
            title: "Purchase Of Car",
            items: [
              FieldEntryModel(
                id: '123',
                title: "Muneeb Masood",
                SOP: 1000,
                price: 2000,
                timeline: DateTime.now(),
                lastUpdated: DateTime.now(),
              ),

              FieldEntryModel(
                id: '123',
                title: "Muneeb Masood",
                SOP: 1000,
                price: 2000,
                timeline: DateTime.now(),
                lastUpdated: DateTime.now(),
              ),
              FieldEntryModel(
                id: '124',
                title: "Muneeb Masood",
                SOP: 1000,
                price: 2000,
                timeline: DateTime.now(),
                lastUpdated: DateTime.now(),
              ),

              FieldEntryModel(
                id: '125',
                title: "Muneeb Masood",
                SOP: 1000,
                price: 2000,
                timeline: DateTime.now(),
                lastUpdated: DateTime.now(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
