import 'package:action_inc_taxi_app/core/enums.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';

import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';

import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/renewal_and_status/renewal_and_status_cubit.dart';
import 'package:action_inc_taxi_app/cubit/renewal_and_status/renewal_and_status_state.dart';

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
    // _cubit.close();
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
                    vertical: 20.h,
                    horizontal: 32.w,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 18.h,
                            horizontal: 24.w,
                          ),
                          child:
                              BlocBuilder<
                                RenewalAndStatusCubit,
                                RenewalAndStatusState
                              >(
                                builder: (context, state) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const ResponsiveText(
                                            'Renewal & Status',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          ResponsiveText(
                                            'Track your renewal progress',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Flexible(
                                        child: CustomTabBar(
                                          tabs: const [
                                            'This week',
                                            'Month',
                                            'Year',
                                          ],
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
                                          backgroundColor: Colors.white10,
                                          selectedColor: const Color(
                                            0xFF2ECC40,
                                          ),
                                          unselectedTextColor: Colors.white54,
                                          selectedTextColor: Colors.white,
                                          height: 38,
                                          borderRadius: 20,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                        ),
                        Divider(color: Colors.white10, height: 1, thickness: 1),
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
                              child: BlocBuilder<RenewalAndStatusCubit, RenewalAndStatusState>(
                                builder: (context, state) {
                                  List<Map<String, dynamic>> rows = [];
                                  if (state is RenewalAndStatusLoaded) {
                                    rows = state.filteredRows;
                                  }
                                  if (state is RenewalAndStatusLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFF2ECC40),
                                            ),
                                      ),
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
                                            size: 56,
                                            color: Colors.red[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24.w,
                                            ),
                                            child: ResponsiveText(
                                              'Failed to load renewals:\n${state.error}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton.icon(
                                            onPressed: () => context
                                                .read<RenewalAndStatusCubit>()
                                                .load(),
                                            icon: const Icon(Icons.refresh),
                                            label: const ResponsiveText(
                                              'Retry',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF2ECC40,
                                              ),
                                              foregroundColor: Colors.black,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 24.w,
                                                vertical: 12.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
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
                                            size: 56,
                                            color: Colors.white24,
                                          ),
                                          const SizedBox(height: 16),
                                          const ResponsiveText(
                                            'No renewals found',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ResponsiveText(
                                            'There are no renewals matching the selected time period',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton.icon(
                                            onPressed: () => context
                                                .read<RenewalAndStatusCubit>()
                                                .load(),
                                            icon: const Icon(Icons.refresh),
                                            label: const ResponsiveText(
                                              'Refresh',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF2ECC40,
                                              ),
                                              foregroundColor: Colors.black,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 24.w,
                                                vertical: 12.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
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
                                        dataRowHeight: 64.h,
                                        dividerThickness: 1,
                                        columnSpacing: 40.w,
                                        horizontalMargin: 24.w,
                                        headingRowHeight: 56.h,
                                        columns: const [
                                          DataColumn(
                                            label: _TableHeader('Renewals'),
                                          ),
                                          DataColumn(
                                            label: _TableHeader('Taxi Number'),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: _TableHeader('Status'),
                                            ),
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
                                                    Center(
                                                      child: _StatusPill(
                                                        row['status'] ?? '',
                                                      ),
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

  RenewalStatus get renewalStatus {
    try {
      return RenewalStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == status.toLowerCase(),
        orElse: () => RenewalStatus.future,
      );
    } catch (_) {
      return RenewalStatus.future;
    }
  }

  bool get isFuture => renewalStatus == RenewalStatus.future;

  String get label {
    switch (renewalStatus) {
      case RenewalStatus.complete:
        return 'Repaired';
      case RenewalStatus.applied:
        return 'Applied';
      case RenewalStatus.rejected:
        return 'Rejected';
      case RenewalStatus.inProgress:
        return 'On Process';
      case RenewalStatus.future:
        return 'Future';
    }
  }

  Color get bgColor {
    switch (renewalStatus) {
      case RenewalStatus.complete:
        return const Color(0xFF2ECC40).withOpacity(0.2);
      case RenewalStatus.applied:
        return const Color(0xFF6EEBFF).withOpacity(0.2);
      case RenewalStatus.rejected:
        return const Color(0xFFFF6B6B).withOpacity(0.2);
      case RenewalStatus.inProgress:
        return const Color(0xFF7A8FFF).withOpacity(0.2);
      case RenewalStatus.future:
        return const Color(0xFFB2BABB).withOpacity(0.2);
    }
  }

  Color get textColor {
    switch (renewalStatus) {
      case RenewalStatus.complete:
        return const Color(0xFF2ECC40);
      case RenewalStatus.applied:
        return const Color(0xFF6EEBFF);
      case RenewalStatus.rejected:
        return const Color(0xFFFF6B6B);
      case RenewalStatus.inProgress:
        return const Color(0xFF7A8FFF);
      case RenewalStatus.future:
        return const Color(0xFFB2BABB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: ResponsiveText(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.3,
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
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 2.w),
      child: ResponsiveText(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.5,
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
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 2.w),
      child: ResponsiveText(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
