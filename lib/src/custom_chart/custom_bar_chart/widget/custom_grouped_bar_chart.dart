import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/model/grouped_bar_data.dart';

class CustomGroupedBarChart extends StatelessWidget {
  final double groupWidth;
  final List<GroupedBarData> data;
  final double height;
  final double maxPrimaryValue;
  final int primaryAxisSteps;
  final double maxSecondaryValue;
  final int secondaryAxisSteps;
  final String? firstBarText;
  final String? secondBarText;
  final bool showDots;
  final bool showLine;
  final Color targetColor;
  final Color actualColor;
  final Color percentColor;

  const CustomGroupedBarChart(
      {super.key,
      this.groupWidth = 95.0,
      required this.data,
      this.height = 350,
      this.maxPrimaryValue = 350,
      this.primaryAxisSteps = 8,
      this.maxSecondaryValue = 120,
      this.secondaryAxisSteps = 7,
      this.showDots = true, // Default to showing dots
      this.showLine = true,
      this.targetColor = const Color(0xFFFFC000),
      this.actualColor = const Color(0xFF00B050),
      this.percentColor = const Color(0xFF4472C4),
      this.firstBarText,
      this.secondBarText});

  @override
  Widget build(BuildContext context) {
    // 40px reserved for X-axis labels at the bottom
    double gridAreaHeight = height - 40;


    return SizedBox(
        height: height + 50, // Added 50px for top Legend spacing
        child: Column(children: [
          _buildLegend(),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftAxis(gridAreaHeight),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    children: [
                      _buildGridLines(gridAreaHeight),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Stack(
                          children: [
                            // 1. Draw the connecting dashed line first (Background layer)
                            if (showLine && data.length > 1)
                              CustomPaint(
                                size: Size(
                                    groupWidth * data.length, gridAreaHeight),
                                painter: _DashedLinePainter(
                                  data: data,
                                  maxSecondaryValue: maxSecondaryValue,
                                  lineColor: percentColor,
                                  groupWidth: groupWidth,
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data
                                  .map((e) => _buildGroup(e, gridAreaHeight))
                                  .toList(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: targetColor, text: firstBarText ?? "Target"),
        const SizedBox(width: 16),
        _LegendItem(color: actualColor, text: secondBarText ?? "Actual"),
        if (showDots) ...[
          const SizedBox(width: 16),
          _LegendItem(color: percentColor, text: "%", isPercent: true),
        ],
      ],
    );
  }

  Widget _buildLeftAxis(double height) {
    return SizedBox(
      height: height,
      width: 35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(primaryAxisSteps, (index) {
          double val = maxPrimaryValue -
              (index * (maxPrimaryValue / (primaryAxisSteps - 1)));
          return SizedBox(
            height: 20,
            child: Text(val.toInt().toString(),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
          );
        }),
      ),
    );
  }

  // Widget _buildRightAxis(double height) {
  //   return SizedBox(
  //     height: height,
  //     width: 30,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: List.generate(secondaryAxisSteps, (index) {
  //         double val = maxSecondaryValue -
  //             (index * (maxSecondaryValue / (secondaryAxisSteps - 1)));
  //         return SizedBox(
  //           height: 20,
  //           child: Text(val.toInt().toString(),
  //               style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
  //         );
  //       }),
  //     ),
  //   );
  // }

  Widget _buildGridLines(double height) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(primaryAxisSteps, (index) {
          return const Divider(
              height: 20, thickness: 1, color: Color(0xFFF0F0F0));
        }),
      ),
    );
  }

  Widget _buildGroup(GroupedBarData item, double height) {
    double usableHeight = height - 20;
    double barMaxHeight = usableHeight - 20;

    double targetHeight = (item.target / maxPrimaryValue) * barMaxHeight;
    double actualHeight = (item.actual / maxPrimaryValue) * barMaxHeight;
    double percentHeight = (item.percentage / maxSecondaryValue) * barMaxHeight;

    // Use specific item color if provided, otherwise use chart theme color
    final Color currentTargetColor = item.targetColor ?? targetColor;
    final Color currentActualColor = item.actualColor ?? actualColor;
    final Color currentDotColor = item.dotColor ?? percentColor;

    return SizedBox(
      width: groupWidth,
      child: Column(
        children: [
          SizedBox(
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: 0,
                  top: 10,
                  bottom: 10,
                  child: Container(width: 1, color: const Color(0xFFF0F0F0)),
                ),
                // Target Bar
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(item.target.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade700)),
                      const SizedBox(height: 4),
                      Container(
                          width: 28,
                          height: targetHeight.clamp(0.0, double.infinity),
                          color: currentTargetColor),
                    ],
                  ),
                ),
                // Actual Bar
                Positioned(
                  bottom: 10,
                  left: 42,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(item.actual.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade700)),
                      const SizedBox(height: 4),
                      Container(
                          width: 28,
                          height: actualHeight.clamp(0.0, double.infinity),
                          color: currentActualColor),
                    ],
                  ),
                ),
                // Percent Floating Dot (Conditional)
                if (showDots)
                  Positioned(
                    bottom: 10 + percentHeight - 4,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${item.percentage.toInt()}%',
                            style: TextStyle(
                                color: currentDotColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: currentDotColor, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // X-Axis
          Container(
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
            ),
            child: Text(item.label,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          )
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final bool isPercent;

  const _LegendItem(
      {required this.color, required this.text, this.isPercent = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 24, height: 12, color: color),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final List<GroupedBarData> data;
  final double maxSecondaryValue;
  final Color lineColor;
  final double groupWidth;

  _DashedLinePainter({
    required this.data,
    required this.maxSecondaryValue,
    required this.lineColor,
    required this.groupWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    double usableHeight = size.height - 20;
    double barMaxHeight = usableHeight - 20;

    for (int i = 0; i < data.length; i++) {
      // Calculate X: Center of the group
      double x = (i * groupWidth) + (groupWidth / 2);

      // Calculate Y: Inverse of percentage height (bottom-up)
      double percentHeight =
          (data[i].percentage / maxSecondaryValue) * barMaxHeight;
      double y = size.height - 10 - percentHeight;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Convert solid path to dashed path
    canvas.drawPath(_dashPath(path, 6, 4), paint);
  }

  Path _dashPath(Path source, double dashWidth, double dashSpace) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dest.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
