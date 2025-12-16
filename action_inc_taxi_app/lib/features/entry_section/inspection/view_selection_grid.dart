import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:flutter/material.dart';

class ViewSelectionGrid extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTapIndex;
  const ViewSelectionGrid({
    super.key,
    required this.selectedIndex,
    required this.onTapIndex,
  });

  @override
  State<ViewSelectionGrid> createState() => _ViewSelectionGridState();
}

class _ViewSelectionGridState extends State<ViewSelectionGrid> {
  int selectedIndex = 0;

  final List<Map<String, String>> views = [
    {"asset": AppAssets.frontView, "label": "Front View"},
    {"asset": AppAssets.rearView, "label": "Rear View"},
    {"asset": AppAssets.topView, "label": "Top View"},
    {"asset": AppAssets.bottomView, "label": "Bottom View"},
    {"asset": AppAssets.leftView, "label": "Left View"},
    {"asset": AppAssets.rightView, "label": "Right View"},
    {"asset": AppAssets.mechanicalPart, "label": "Mechanical Part"},
    {"asset": AppAssets.interior, "label": "Interior"},
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.75,
      children: List.generate(views.length, (index) {
        final asset = views[index]["asset"]!;
        final label = views[index]["label"]!;
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onTapIndex(index);
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF181917),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.green
                    : Colors.white.withOpacity(0.15),
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    asset,
                    width: 120,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
