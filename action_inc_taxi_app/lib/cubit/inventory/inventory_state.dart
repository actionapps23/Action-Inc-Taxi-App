import 'package:action_inc_taxi_app/core/models/inventory_item_model.dart';
import 'package:action_inc_taxi_app/core/models/inventory_section_model.dart';

class InventoryState {
  List<InventorySectionModel>? data;
  List<InventoryItemModel>? inventoryItems;
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  InventoryLoaded({
    required List<InventorySectionModel> data,
    required List<InventoryItemModel> inventoryItems,
  }) {
    super.data = data;
    super.inventoryItems = inventoryItems;
  }
}

class InventoryAdding extends InventoryState {}

class InventoryUpdating extends InventoryState {}

class InventoryError extends InventoryState {
  final String message;

  InventoryError({required this.message});
}

class InventorySuccess extends InventoryState {
  final String message;

  InventorySuccess({required this.message});
}
