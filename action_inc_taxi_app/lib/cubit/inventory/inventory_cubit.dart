import 'package:action_inc_taxi_app/core/models/inventory_section_model.dart';
import 'package:action_inc_taxi_app/cubit/inventory/inventory_state.dart';
import 'package:action_inc_taxi_app/services/inventory_db_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(InventoryInitial());

  Future<void> loadInventory() async {
    emit(InventoryLoading());
    final data = await InventoryDBService.fetchInventoryData();
    filterByCategory("engine", data);
  }

  Future<void> addFiledsToCategory(
    InventorySectionModel inventorySectionModel,
  ) async {
    emit(InventoryAdding());
    try {
      await InventoryDBService.addFiledsToCategory(inventorySectionModel);
      await loadInventory();
    } catch (e) {
      emit(InventoryError(message: e.toString()));
    }
  }

  void filterByCategory(
    String categoryName, [
    List<InventorySectionModel>? data,
  ]) {
    final inventorySections = data ?? state.data;
    if (inventorySections == null) {
      emit(InventoryError(message: "No data available"));
      return;
    }
    final filtered = inventorySections
        .where((item) => item.name == categoryName)
        .toList();
    if (filtered.isEmpty) {
      emit(InventoryLoaded(data: inventorySections, inventoryItems: []));
      return;
    }
    final items = filtered.first.items;
    emit(InventoryLoaded(data: inventorySections, inventoryItems: items));
  }
}
