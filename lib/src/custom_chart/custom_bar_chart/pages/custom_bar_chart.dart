import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/model/custom_bar_data.dart';

class CustomBarChart extends StatelessWidget {
  final List<CustomBarData> data;
  final double height;
  final double width;
  final Color axisColor;
  final double barWidth;
  final double borderRadius;
  final TextStyle? labelStyle;

  const CustomBarChart({
    super.key,
    required this.data,
    this.height = 300,
    this.width = double.infinity,
    this.axisColor = Colors.grey,
    this.barWidth = 30,
    this.borderRadius = 4,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    double maxValue = data.map((e) => e.value).fold(0, (prev, e) => e > prev ? e : prev);
    if (maxValue <= 0) maxValue = 1.0;

    return SizedBox(
      height: height,
      width: width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // --- FIXED DIMENSIONS ---
          const double valueLabelHeight = 20.0;
          const double innerGap = 4.0;            // The gap that caused the 4px error
          const double bottomLabelHeight = 25.0;
          const double dividerHeight = 1.0;
          const double outerSpacing = 12.0;

          // 1. Calculate total area available for the "Bar + Value" section
          final double totalChartArea = constraints.maxHeight -
              bottomLabelHeight -
              outerSpacing -
              dividerHeight;

          // 2. Subtract BOTH the label height AND the inner gap to find true max bar height
          final double maxPossibleBarHeight = totalChartArea - valueLabelHeight - innerGap;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((item) {
              // Calculate bar height safely
              final double barHeight = (item.value / maxValue) * maxPossibleBarHeight;

              return Expanded(
                child: Column(
                  children: [
                    // A. The Chart Area (Value + Gap + Bar)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Value Label
                          SizedBox(
                            height: valueLabelHeight,
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  item.value.toStringAsFixed(0),
                                  style: labelStyle ?? const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: innerGap), // Exactly 4.0 pixels

                          // The Bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: barHeight.clamp(0, maxPossibleBarHeight),
                            width: barWidth,
                            decoration: BoxDecoration(
                              color: item.color,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(borderRadius),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // B. Divider & Bottom Label
                    SizedBox(height: outerSpacing / 2),
                    Divider(color: axisColor, height: dividerHeight, thickness: 1),
                    SizedBox(height: outerSpacing / 2),
                    SizedBox(
                      height: bottomLabelHeight,
                      child: Center(
                        child: Text(
                          item.label,
                          style: labelStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}