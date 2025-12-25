import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/inventory_item_model.dart';
import 'package:action_inc_taxi_app/core/widgets/add_inventory_popup.dart';
import 'package:action_inc_taxi_app/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';

class InventoryTable extends StatelessWidget {
  final List<InventoryItemModel> items;
  const InventoryTable({super.key, required this.items});

  Color _statusTextColor(String type) {
    switch (type) {
      case 'in':
        return Colors.white;
      case 'low':
        return Colors.white;
      case 'out':
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181917),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: ResponsiveText(
                    'Product Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ResponsiveText(
                    'Quantity',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ResponsiveText(
                    'Stock Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ResponsiveText(
                    'Required Quantity',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white12, height: 1),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddInventoryPopup(item: item),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ResponsiveText(
                        item.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ResponsiveText(
                        item.totalAvailable.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        child: StatusChip(
                          label: HelperFunctions.stringFromInventoryStatus(
                            item.stockStatus,
                          ),
                          color: Colors.transparent,
                          textColor: _statusTextColor(item.stockStatus.name),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ResponsiveText(
                        item.totalNeeded.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
