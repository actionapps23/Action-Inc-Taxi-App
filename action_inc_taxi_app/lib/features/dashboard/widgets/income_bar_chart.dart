import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';

class IncomeBarChart extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double cardPadding = width * 0.04;
    final double borderRadius = width * 0.05;
    final double barWidth = width * 0.08;
    final double chartHeight = 180.0;
    final int maxValue = values.reduce((a, b) => a > b ? a : b);

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
          Row(
            children: [
              Text(
                'Total Income',
              
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _TabButton(label: 'Monthly', selected: true),
                    _TabButton(label: 'Weekly'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: chartHeight + 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('30K', style: AppTextStyles.bodyExtraSmall.copyWith(color: Colors.white)),
                    Text('20K', style: AppTextStyles.bodyExtraSmall.copyWith(color: Colors.white)),
                    Text('10K', style: AppTextStyles.bodyExtraSmall.copyWith(color: Colors.white)),
                    Text('0', style: AppTextStyles.bodyExtraSmall.copyWith(color: Colors.white)),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(values.length, (i) {
                        final isHighlighted = i == highlightedIndex;
                        final barHeight = (values[i] / (maxValue == 0 ? 1 : maxValue)) * chartHeight;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (isHighlighted)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '$currencySymbol ${values[i]}',
                                    style: AppTextStyles.bodyExtraSmall.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                width: barWidth,
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color: isHighlighted ? AppColors.primary : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(barWidth / 2),
                                ),
                              ),
                              Text(
                                labels[i],
                                style: AppTextStyles.bodyExtraSmall.copyWith(color: Colors.white),
                              ),
                            ],
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

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  const _TabButton({required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
