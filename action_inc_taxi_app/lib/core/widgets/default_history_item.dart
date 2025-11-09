import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultHistoryItem extends StatelessWidget {
  final String userName;
  final String userRole;
  final String reason;
  final String date;
  final List<Widget> attachments;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Color backgroundColor;

  const DefaultHistoryItem({
    super.key,
    required this.userName,
    required this.userRole,
    required this.reason,
    required this.date,
    required this.attachments,
    this.onDelete,
    this.onEdit,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    userRole,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white54,
                      size: 20,
                    ),
                    onPressed: onDelete,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white54,
                      size: 20,
                    ),
                    onPressed: onEdit,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            reason,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 4.h),
          Text(
            date,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          SizedBox(height: 8.h),
          const Text(
            'Attachments',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8.h),
          Row(children: attachments),
        ],
      ),
    );
  }
}
