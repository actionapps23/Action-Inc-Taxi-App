import 'package:action_inc_taxi_app/core/models/enums.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';

import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/renewal_and_status_cubit.dart';
import 'package:action_inc_taxi_app/cubit/renewal_and_status_state.dart';

class RenewalAndStatusScreen extends StatefulWidget {
  final Color? backgroundColor;
  final void Function(int)? onFilterChanged;

  const RenewalAndStatusScreen({
    super.key,
    this.backgroundColor,
    this.onFilterChanged,
  });

  @override
  State<RenewalAndStatusScreen> createState() => _RenewalAndStatusScreenState();
}

class _RenewalAndStatusScreenState extends State<RenewalAndStatusScreen> {
  late final RenewalAndStatusCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = RenewalAndStatusCubit(DbService());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget scaffold = BlocProvider.value(
      value: _cubit,
      child: BlocListener<RenewalAndStatusCubit, RenewalAndStatusState>(
        listener: (context, state) {
          if (state is RenewalAndStatusFailure) {
            SnackBarHelper.showErrorSnackBar(context, state.error);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              const Navbar(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 32.w,
                  ),
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
                          child:
                              BlocBuilder<
                                RenewalAndStatusCubit,
                                RenewalAndStatusState
                              >(
                                builder: (context, state) {
                                  int selected = 0;
                                  if (state is RenewalAndStatusLoaded)
                                    selected = state.selectedFilter;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          tabs: const [
                                            'This week',
                                            'Month',
                                            'Year',
                                          ],
                                          selectedIndex: selected,
                                          onTabSelected:
                                              widget.onFilterChanged ??
                                              (i) {
                                                context
                                                    .read<
                                                      RenewalAndStatusCubit
                                                    >()
                                                    .filterBy(i);
                                              },
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 0,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          selectedColor: const Color(
                                            0xFF2ECC40,
                                          ),
                                          unselectedTextColor: Colors.white70,
                                          selectedTextColor: Colors.white,
                                          height: 36,
                                          borderRadius: 20,
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                            final double maxHeight =
                                constraints.maxHeight.isFinite
                                ? constraints.maxHeight
                                : fallbackMaxHeight;

                            return ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: maxHeight),
                              child: BlocBuilder<
                                RenewalAndStatusCubit,
                                RenewalAndStatusState
                              >(
                                builder: (context, state) {
                                  List<Map<String, dynamic>> rows = [];
                                  if (state is RenewalAndStatusLoaded) {
                                    rows = state.filteredRows;
                                  }
                                  if (state is RenewalAndStatusLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  // On failure show a friendly error block with retry.
                                  if (state is RenewalAndStatusFailure) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 48,
                                            color: Colors.red[400],
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24.w,
                                            ),
                                            child: Text(
                                              'Failed to load renewals:\n${state.error}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton(
                                            onPressed: () => context
                                                .read<
                                                  RenewalAndStatusCubit
                                                >()
                                                .load(),
                                            child: const Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  // When loaded but no rows, show an empty state with a retry option.
                                  if (state is RenewalAndStatusLoaded &&
                                      rows.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.inbox_outlined,
                                            size: 48,
                                            color: Colors.white24,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'No renewals found',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton(
                                            onPressed: () => context
                                                .read<
                                                  RenewalAndStatusCubit
                                                >()
                                                .load(),
                                            child: const Text('Refresh'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  // Make the table vertically scrollable
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
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
                                          DataColumn(
                                            label: _TableHeader('Renewals'),
                                          ),
                                          DataColumn(
                                            label: _TableHeader(
                                              'Taxi Number',
                                            ),
                                          ),
                                          DataColumn(
                                            label: _TableHeader('Status'),
                                          ),
                                          DataColumn(
                                            label: _TableHeader(
                                              'Required Date',
                                            ),
                                          ),
                                        ],
                                        rows: rows
                                            .map(
                                              (row) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    _TableCell(
                                                      row['renewal'] ?? '',
                                                    ),
                                                  ),
                                                  DataCell(
                                                    _TableCell(
                                                      row['taxi'] ?? '',
                                                    ),
                                                  ),
                                                  DataCell(
                                                    _StatusPill(
                                                      row['status'] ?? '',
                                                    ),
                                                  ),
                                                  DataCell(
                                                    _TableCell(
                                                      row['date'] ?? '',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
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
        ),
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

  RenewalStatus? get renewalStatus {
    try {
      return RenewalStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == status.toLowerCase(),
        orElse: () => RenewalStatus.inProgress,
      );
    } catch (_) {
      return null;
    }
  }

  String get label {
    switch (renewalStatus) {
      case RenewalStatus.complete:
        return 'Repaired';
      case RenewalStatus.applied:
        return 'Applied';
      case RenewalStatus.rejected:
        return 'Rejected';
      case RenewalStatus.inProgress:
      default:
        return 'On Process';
    }
  }

  Color get bgColor {
    switch (renewalStatus) {
      case RenewalStatus.complete:
        // Green (Repaired)
        return const Color(0xFF6EFF8E);
      case RenewalStatus.applied:
        // Blue (Applied)
        return const Color(0xFF6EEBFF);
      case RenewalStatus.rejected:
        // Red (Rejected)
        return const Color(0xFFFF6B6B);
      case RenewalStatus.inProgress:
      default:
        // Blue-gray (On Process)
        return const Color(0xFF7A8FFF);
    }
  }

  Color get textColor => Colors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 80.w),
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.2,
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
