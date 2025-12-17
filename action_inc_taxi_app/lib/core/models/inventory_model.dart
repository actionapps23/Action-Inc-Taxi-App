import 'package:action_inc_taxi_app/core/enums.dart';

class InventoryModel {
  final List<InventorySection> sections;

  InventoryModel({required this.sections});
}

class InventorySection {
  final String name;
  final List<InventoryItem> items;
  InventorySection({required this.name, required this.items});
}

class InventoryItem {
  final String name;
  final int totalAvailable;
  final int totalNeeded;
  final InventoryStatus stockStatus;

  InventoryItem({
    required this.name,
    required this.totalAvailable,
    required this.totalNeeded,
    required this.stockStatus,
  });
}
