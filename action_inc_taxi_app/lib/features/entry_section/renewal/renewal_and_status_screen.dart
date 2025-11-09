import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';

class RenewalAndStatusScreen extends StatelessWidget {
  final List<Map<String, dynamic>> renewalRows;
  final Color? backgroundColor;
  final int selectedFilter; // 0: This week, 1: Month, 2: Year
  final void Function(int)? onFilterChanged;

  const RenewalAndStatusScreen({
    super.key,
    required this.renewalRows,
    this.backgroundColor,
    this.selectedFilter = 0,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Widget scaffold = Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const Navbar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 32.w),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(0),
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Renewal & Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 260,
                            child: CustomTabBar(
                              tabs: const ['This week', 'Month', 'Year'],
                              selectedIndex: selectedFilter,
                              onTabSelected: onFilterChanged ?? (i) {},
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 0,
                              ),
                              backgroundColor: Colors.transparent,
                              selectedColor: Color(0xFF2ECC40),
                              unselectedTextColor: Colors.white70,
                              selectedTextColor: Colors.white,
                              height: 36,
                              borderRadius: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Ensure the table area gets a finite height.
                    LayoutBuilder(
                      builder: (context, constraints) {
                        debugPrint(
                          'RenewalAndStatusScreen table area constraints: $constraints',
                        );
                        final double fallbackMaxHeight =
                            MediaQuery.of(context).size.height * 0.6;
                        final double maxHeight = constraints.maxHeight.isFinite
                            ? constraints.maxHeight
                            : fallbackMaxHeight;

                        return ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: maxHeight),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              dataRowColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              dividerThickness: 0.5,
                              columnSpacing: 32.w,
                              horizontalMargin: 0,
                              columns: const [
                                DataColumn(label: _TableHeader('Renewals')),
                                DataColumn(label: _TableHeader('Taxi Number')),
                                DataColumn(label: _TableHeader('Status')),
                                DataColumn(
                                  label: _TableHeader('Required Date'),
                                ),
                              ],
                              rows: renewalRows
                                  .map(
                                    (row) => DataRow(
                                      cells: [
                                        DataCell(
                                          _TableCell(row['renewal'] ?? ''),
                                        ),
                                        DataCell(_TableCell(row['taxi'] ?? '')),
                                        DataCell(
                                          _StatusPill(row['status'] ?? ''),
                                        ),
                                        DataCell(_TableCell(row['date'] ?? '')),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: scaffold,
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill(this.status);
  Color get bgColor {
    switch (status.toLowerCase()) {
      case 'repaired':
        return const Color(0xFF7CF88F);
      case 'applied':
        return const Color(0xFF7FD8F8);
      case 'on process':
        return const Color(0xFFFF8C6B);
      default:
        return Colors.grey;
    }
  }

  Color get textColor => Colors.black;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}
