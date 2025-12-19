import 'package:action_inc_taxi_app/core/enums.dart';

class InventoryItemModel {
  final String name;
  final int totalAvailable;
  final int totalNeeded;
  final InventoryStatus stockStatus;

  InventoryItemModel({
    required this.name,
    required this.totalAvailable,
    required this.totalNeeded,
    required this.stockStatus,
  });
}
