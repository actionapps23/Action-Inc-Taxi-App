import 'package:action_inc_taxi_app/core/models/inventory_item_model.dart';

class InventorySectionModel {
  final String name;
  final List<InventoryItemModel> items;
  InventorySectionModel({required this.name, required this.items});

  factory InventorySectionModel.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<InventoryItemModel> itemList = itemsFromJson
        .map((item) => InventoryItemModel.fromJson(item))
        .toList();

    return InventorySectionModel(name: json['name'], items: itemList);
  }
}
