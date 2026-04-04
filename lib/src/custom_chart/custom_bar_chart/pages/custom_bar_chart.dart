import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/model/custom_bar_data.dart';

class CustomBarChart extends StatelessWidget {
  final List<CustomBarData> data;
  final double height;
  final double width;
  final Color axisColor;
  final double barWidth;
  final double barGap;
  final double borderRadius;
  final TextStyle? labelStyle;

  const CustomBarChart({
    super.key,
    required this.data,
    this.height = 300,
    this.width = double.infinity,
    this.axisColor = Colors.grey,
    this.barWidth = 30,
    this.barGap = 4,
    this.borderRadius = 4,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    double maxValue =
        data.map((e) => e.value).fold(0, (prev, e) => e > prev ? e : prev);
    if (maxValue <= 0) maxValue = 1.0;

    // --- FIXED DIMENSIONS ---
    const double valueLabelHeight = 20.0;
    const double innerGap = 4.0;
    const double bottomLabelHeight = 25.0;
    const double dividerHeight = 1.0;
    const double outerSpacing = 12.0;

    final double totalChartArea =
        height - bottomLabelHeight - outerSpacing - dividerHeight;
    final double maxPossibleBarHeight =
        totalChartArea - valueLabelHeight - innerGap;

    return SizedBox(
      height: height,
      width: width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align to start of scroll
          children: [
            // 1. THE BARS & TOP LABELS
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((item) {
                  final double barHeight =
                      (item.value / maxValue) * maxPossibleBarHeight;
                  return Container(
                    width: barWidth + (barGap * 2),
                    padding: EdgeInsets.symmetric(horizontal: barGap),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: valueLabelHeight,
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                item.value.toStringAsFixed(0),
                                style:
                                    labelStyle ?? const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: innerGap),
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
                  );
                }).toList(),
              ),
            ),

            // 2. THE SOLID AXIS LINE (Fixed height spacing included)
            SizedBox(height: outerSpacing / 2),
            Container(
              height: dividerHeight,
              width: (barWidth + (barGap * 2)) * data.length,
              // Total width of all items
              color:
                  axisColor, // Using a Container instead of Divider for a solid look
            ),
            SizedBox(height: outerSpacing / 2),

            // 3. THE BOTTOM LABELS (X-Axis Labels)
            Row(
              children: data.map((item) {
                return Container(
                  width: barWidth + (barGap * 2),
                  height: bottomLabelHeight,
                  alignment: Alignment.center,
                  child: Text(
                    item.label,
                    style: labelStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
