import 'package:action_inc_taxi_app/core/models/inventory_item_model.dart';
import 'package:action_inc_taxi_app/core/models/inventory_section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryDBService {
  static final String inventoryCollection = 'inventory';

  static final _firebaseFirestore = FirebaseFirestore.instance;

  static Future<void> addFiledsToCategory(
    InventorySectionModel inventorySection,
  ) async {
    for (InventoryItemModel item in inventorySection.items) {
      await _firebaseFirestore
          .collection(inventoryCollection)
          .doc(inventorySection.name)
          .set({"createdAt": FieldValue.serverTimestamp()});

      await _firebaseFirestore
          .collection(inventoryCollection)
          .doc(inventorySection.name)
          .collection(inventorySection.name)
          .doc(item.name)
          .set(item.toJson());
    }
  }

  static Future<List<InventorySectionModel>> fetchInventoryData() async {
    try {
      QuerySnapshot sectionSnapshot = await _firebaseFirestore
          .collection(inventoryCollection)
          .get();

      List<InventorySectionModel> sections = [];

      for (var doc in sectionSnapshot.docs) {
        String sectionName = doc.id;
        QuerySnapshot itemsSnapshot = await _firebaseFirestore
            .collection(inventoryCollection)
            .doc(sectionName)
            .collection(sectionName)
            .get();

        List<InventoryItemModel> items = itemsSnapshot.docs.map((itemDoc) {
          return InventoryItemModel.fromJson(
            itemDoc.data() as Map<String, dynamic>,
          );
        }).toList();

        sections.add(InventorySectionModel(name: sectionName, items: items));
      }
      return sections;
    } catch (e) {
      throw Exception("Error fetching inventory data: $e");
    }
  }

  static Future<void> updateInventoryItem(
    InventorySectionModel inventorySectionModel,
    String previousFieldName,
  ) async {
    try {
      if (previousFieldName != inventorySectionModel.name) {
        // If the category name has changed, we need to move the document
        // Delete the old document
        await _firebaseFirestore
            .collection(inventoryCollection)
            .doc(previousFieldName)
            .collection(previousFieldName)
            .doc(inventorySectionModel.items[0].name)
            .delete();

        // Create a new document with the updated category name
        await _firebaseFirestore
            .collection(inventoryCollection)
            .doc(inventorySectionModel.name)
            .set({"createdAt": FieldValue.serverTimestamp()});

        await _firebaseFirestore
            .collection(inventoryCollection)
            .doc(inventorySectionModel.name)
            .collection(inventorySectionModel.name)
            .doc(inventorySectionModel.items[0].name)
            .set(inventorySectionModel.items[0].toJson());
        return;
      }
      await _firebaseFirestore
          .collection(inventoryCollection)
          .doc(previousFieldName)
          .collection(previousFieldName)
          .doc(inventorySectionModel.items[0].name)
          .update(inventorySectionModel.items[0].toJson());
    } catch (e) {
      ("Error updating inventory item: $e");
      throw Exception("Error updating inventory item: $e");
    }
  }
}
