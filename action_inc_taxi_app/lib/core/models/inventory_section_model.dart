import 'package:action_inc_taxi_app/core/models/inventory_item_model.dart';

class InventorySectionModel {
  final String name;
  final List<InventoryItemModel> items;
  InventorySectionModel({required this.name, required this.items});
}
