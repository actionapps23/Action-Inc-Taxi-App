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

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      name: json['name'],
      totalAvailable: json['totalAvailable'],
      totalNeeded: json['totalNeeded'],
      stockStatus: InventoryStatus.values.firstWhere(
        (e) => e.name == json['stockStatus'],
        orElse: () => InventoryStatus.outOfStock,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalAvailable': totalAvailable,
      'totalNeeded': totalNeeded,
      'stockStatus': stockStatus.name,
    };
  }
}
