import 'package:action_inc_taxi_app/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';

class InventoryTable extends StatelessWidget {
  InventoryTable({super.key});

  final List<Map<String, String>> items = const [
    {
      'name': 'Transmission Oil',
      'qty': '47 Litre',
      'status': 'In Stock',
      'statusType': 'in',
      'req': '0 Litre',
    },
    {
      'name': 'Collant',
      'qty': '47 Litre',
      'status': 'Low Stock',
      'statusType': 'low',
      'req': '13 Litre',
    },
    {
      'name': 'Mobil',
      'qty': '0 Litre',
      'status': 'Out of Stock',
      'statusType': 'out',
      'req': '100 Litre',
    },
    {
      'name': 'Fuel',
      'qty': '0 Litre',
      'status': 'Out of Stock',
      'statusType': 'out',
      'req': '100 Litre',
    },
    {
      'name': 'Break Pads',
      'qty': '0 pcs',
      'status': 'Out of Stock',
      'statusType': 'out',
      'req': '50 pcs',
    },
  ];

  Color _statusColor(String type) {
    switch (type) {
      case 'in':
        return AppColors.success;
      case 'low':
        return Colors.cyanAccent;
      case 'out':
      default:
        return AppColors.error;
    }
  }

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
                  child: Text('Product Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Quantity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Stock Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Required Quantity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white12, height: 1),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(item['name']!, style: const TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 2,
                  child: Text(item['qty']!, style: const TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: StatusChip(
                      label: item['status']!,
                      color: Colors.transparent,
                      textColor: _statusTextColor(item['statusType']!),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(item['req']!, style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
