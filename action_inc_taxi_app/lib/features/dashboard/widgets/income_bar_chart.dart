import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';

class IncomeBarChart extends StatefulWidget {
  final List<int> values;
  final List<String> labels;
  final int highlightedIndex;
  final String currencySymbol;

  const IncomeBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.highlightedIndex = 3,
    this.currencySymbol = '₱',
  });

  @override
  _IncomeBarChartState createState() => _IncomeBarChartState();
}

class _IncomeBarChartState extends State<IncomeBarChart> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    final maxIndex = (widget.values.isEmpty ? 0 : widget.values.length - 1);
    _selectedIndex = widget.highlightedIndex.clamp(0, maxIndex);
  }

  @override
  void didUpdateWidget(covariant IncomeBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlightedIndex != widget.highlightedIndex) {
      final maxIndex = (widget.values.isEmpty ? 0 : widget.values.length - 1);
      _selectedIndex = widget.highlightedIndex.clamp(0, maxIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardPadding = 16.w;
    final bubbleH = 28.h;
    final double borderRadius = 12.r;
    final double barWidth = 28.w;
    final double chartHeight = 180.h;
    final int maxValue = widget.values.isEmpty
        ? 0
        : widget.values.reduce((a, b) => a > b ? a : b);

    // dynamic Y-axis labels
    const int ticks = 3; // creates ticks+1 labels (e.g. 3 -> 4 labels)
    String _fmt(int v) {
      if (v >= 1000) {
        if (v % 1000 == 0) return '${v ~/ 1000}K';
        return '${(v / 1000).toStringAsFixed(1)}K';
      }
      return v.toString();
    }

    final List<String> yLabels = List.generate(ticks + 1, (i) {
      if (maxValue == 0) return '0';
      final value = ((maxValue) * (ticks - i) / ticks).round();
      return _fmt(value);
    });

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(children: [ResponsiveText('Total Income'), const Spacer()]),
          Spacing.vMedium,
          SizedBox(
            height: (chartHeight + 40.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis labels (generated from maxValue)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: yLabels
                      .map(
                        (t) => ResponsiveText(
                          '₱$t',
                          style: AppTextStyles.bodyExtraSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      )
                      .toList(),
                ),
                Spacing.hSize(12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(widget.values.length, (i) {
                        final isHighlighted = i == _selectedIndex;
                        final barHeight =
                            (widget.values[i] /
                                (maxValue == 0 ? 1 : maxValue)) *
                            chartHeight;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = i;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (!isHighlighted) SizedBox(height: bubbleH),

                                if (isHighlighted)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: ResponsiveText(
                                      '${widget.currencySymbol} ${widget.values[i]}',
                                      style: AppTextStyles.bodyExtraSmall
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                Flexible(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    width: barWidth,
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      color: isHighlighted
                                          ? AppColors.primary
                                          : Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(
                                        (barWidth / 4).r,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacing.vSmall,
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: barWidth + 8.w,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: ResponsiveText(
                                      widget.labels[i],
                                      style: AppTextStyles.bodyExtraSmall
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
