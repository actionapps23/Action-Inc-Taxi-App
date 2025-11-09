import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'default_history_item.dart';

class DefaultHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const DefaultHistoryList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Default History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              Divider(color: Colors.white24, thickness: 1, height: 16.h),
          itemBuilder: (context, index) {
            final item = items[index];
            return DefaultHistoryItem(
              userName: item['userName'],
              userRole: item['userRole'],
              reason: item['reason'],
              date: item['date'],
              attachments: item['attachments'],
              onDelete: item['onDelete'],
              onEdit: item['onEdit'],
              backgroundColor: Colors.transparent,
            );
          },
        ),
      ],
    );
  }
}
