import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable, responsive table-like widget to display a list of
/// `FieldEntryModel` (checklist / procedure / purchase steps).
///
/// Usage:
/// ChecklistTable(
///   title: 'Purchase of Car',
///   items: myItems,
///   onEdit: (item) => ...,
///   onToggleComplete: (item, value) => ...,
/// )
class ChecklistTable extends StatelessWidget {
  final String title;
  final List<FieldEntryModel> items;
  final void Function(FieldEntryModel item)? onEdit;
  final void Function(FieldEntryModel item, bool completed)? onToggleComplete;
  final double? maxHeight;

  const ChecklistTable({
    Key? key,
    required this.title,
    required this.items,
    this.onEdit,
    this.onToggleComplete,
    this.maxHeight,
  }) : super(key: key);

  Widget _headerCell(String text, {double flex = 1}) {
    return Expanded(
      flex: (flex * 1000).toInt(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: ResponsiveText(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _dataCell(Widget child, {double flex = 1}) {
    return Expanded(
      flex: (flex * 1000).toInt(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final table = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ResponsiveText(
              title,
              style: AppTextStyles.h3.copyWith(color: AppColors.surface),
            ),
          ),
        ),
        Spacing.vMedium,

        // Table card
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              // Header row
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    _headerCell('Purchase Step', flex: 3),
                    _headerCell('SOP', flex: 1),
                    _headerCell('Price', flex: 1),
                    _headerCell('Timeline', flex: 1),
                    _headerCell('Last Update', flex: 1.5),
                    _headerCell('Edit', flex: 0.6),
                    _headerCell('Check Box', flex: 0.6),
                  ],
                ),
              ),

              // Divider
              Divider(height: 1.h, color: AppColors.border),

              // Rows list
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight ?? 400.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: items.map((item) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _dataCell(
                                ResponsiveText(
                                  item.title,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.surface,
                                  ),
                                  maxLines: 2,
                                ),
                                flex: 3,
                              ),
                              _dataCell(
                                ResponsiveText(
                                  item.SOP.toString(),
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                              _dataCell(
                                ResponsiveText(
                                  '${item.price} P',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                              _dataCell(
                                ResponsiveText(
                                  // timeline assumed as DateTime; show relative or days if needed
                                  '${_formatTimeline(item.timeline)}',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                              _dataCell(
                                ResponsiveText(
                                  _formatDate(item.lastUpdated),
                                  style: AppTextStyles.bodyMedium,
                                ),
                                flex: 1.5,
                              ),
                              _dataCell(
                                IconButton(
                                  onPressed: onEdit == null
                                      ? null
                                      : () => onEdit!(item),
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.surface,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                flex: 0.6,
                              ),
                              _dataCell(
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Checkbox(
                                    value: item is FieldEntryModel
                                        ? (true ?? false)
                                        : false,
                                    onChanged: onToggleComplete == null
                                        ? null
                                        : (v) => onToggleComplete!(
                                            item,
                                            v ?? false,
                                          ),
                                  ),
                                ),
                                flex: 0.6,
                              ),
                            ],
                          ),
                          Divider(height: 1.h, color: AppColors.border),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // For small widths show a stacked (card) layout that's mobile-friendly.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Compute a bounded height even when parent constraints are unbounded
          final mq = MediaQuery.of(context);
          final double availableHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : mq.size.height - mq.padding.vertical - kToolbarHeight - 120.h;

          return SizedBox(
            height: availableHeight.clamp(200.h, mq.size.height),
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: ResponsiveText(
                      title,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                ),
                Spacing.vMedium,
                ...items.map((item) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          item.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.surface,
                          ),
                          maxLines: 3,
                        ),
                        Spacing.vSmall,
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 8.h,
                          children: [
                            _infoChip('SOP', item.SOP.toString()),
                            _infoChip('Price', '${item.price} P'),
                            _infoChip(
                              'Timeline',
                              _formatTimeline(item.timeline),
                            ),
                            _infoChip('Last', _formatDate(item.lastUpdated)),
                          ],
                        ),
                        Spacing.vSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: onEdit == null
                                  ? null
                                  : () => onEdit!(item),
                              icon: Icon(Icons.edit, color: AppColors.surface),
                            ),
                            Checkbox(
                              value: false,
                              onChanged: onToggleComplete == null
                                  ? null
                                  : (v) => onToggleComplete!(item, v ?? false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                // bottom spacing so content doesn't hit screen edge
                SizedBox(height: 24.h),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: table,
        );
      },
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.03),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: ResponsiveText(
        '$label: $value',
        style: AppTextStyles.caption.copyWith(color: AppColors.surface),
      ),
    );
  }

  String _formatDate(DateTime d) {
    // Simple date formatting (dd MMM, yyyy)
    return '${d.day.toString().padLeft(2, '0')} ${_month(d.month)} ${d.year}';
  }

  String _month(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(m - 1).clamp(0, 11)];
  }

  String _formatTimeline(DateTime t) {
    // Represent timeline as number of days from now if future, otherwise show formatted date
    final now = DateTime.now();
    final diff = t.difference(now).inDays;
    if (diff > 0 && diff <= 365) return '$diff Days';
    return _formatDate(t);
  }
}
