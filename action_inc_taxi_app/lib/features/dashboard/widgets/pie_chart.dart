import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/core/widgets/tabbar/tabbar.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class PieChart extends StatelessWidget {
  const PieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double cardPadding = width * 0.04;
    final double borderRadius = width * 0.05;
    final double pieSize = width * 0.1;
    final double legendDotSize = width * 0.03;
    // final double titleFontSize = width * 0.05;
    // final double labelFontSize = width * 0.038;
    // final double valueFontSize = width * 0.042;

    final fleets = [
      {"name": "Fleet 1", "amount": 7000},
      {"name": "Fleet 2", "amount": 1000},
      {"name": "Fleet 3", "amount": 5000},
      {"name": "Fleet 4", "amount": 4000},
    ];
    final total = fleets.fold<int>(0, (sum, f) => sum + (f["amount"] as int));
    final List<Color> pieColors = [
      const Color(0xFF6290C3),
      const Color(0xFF6290C3),
      const Color(0xFF1A1B41),
      const Color(0xFFBAFF29),
    ];

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Fleet Income", style: AppTextStyles.bodySmall),
              const Spacer(),
              CustomTabBar(
                tabs: ["Daily Income", "Weekly", "Yearly"],
                selectedIndex: 0,
                onTabSelected: (index) {},
              ),
            ],
          ),
          // Pie chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: pieSize,
                height: pieSize,
                child: CustomPaint(
                  painter: _PieChartPainter(
                    values: fleets.map((f) => f["amount"] as int).toList(),
                    colors: pieColors,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing.vLarge,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Fleet Income",
                        style: AppTextStyles.bodySmall,
                      ),
                      Text("₱ $total", style: AppTextStyles.bodySmall),
                    ],
                  ),
                  Spacing.vStandard,
                  ...List.generate(fleets.length, (i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: legendDotSize,
                                height: legendDotSize,
                                decoration: BoxDecoration(
                                  color: pieColors[i],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Spacing.hStandard,
                              Text(
                                fleets[i]["name"] as String,
                                style: AppTextStyles.bodyExtraSmall,
                              ),
                            ],
                          ),
                          Text(
                            "₱ ${fleets[i]["amount"]}",
                            style: AppTextStyles.bodyExtraSmall,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          Spacing.hLarge,
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<int> values;
  final List<Color> colors;
  _PieChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<int>(0, (sum, v) => sum + v);
    double startRadian = -1.5708; // -90 degrees
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.18
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 6.28319; // 2*PI
      paint.color = colors[i % colors.length];
      canvas.drawArc(rect, startRadian, sweep, false, paint);
      startRadian += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
