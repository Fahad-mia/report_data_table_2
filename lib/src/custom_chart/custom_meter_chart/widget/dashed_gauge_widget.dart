import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/model/design_helper/dashed_gauge_painter.dart';

class DashedMeterWidget extends StatelessWidget {
  final double value;
  final String label;
  final bool isAnimate; // <--- The "True/False" handler

  final double gaugeSize;
  final double arcRadius;
  final double labelFontSize;
  final double valueFontSize;
  final Color activeColorStart;
  final Color activeColorEnd;
  final Color inactiveColor;

  // Animation settings
  final Duration animationDuration;

  const DashedMeterWidget({
    super.key,
    required this.value,
    this.label = "MEMORY",
    this.isAnimate = true, // Defaults to true
    this.gaugeSize = 69,
    this.arcRadius = 90,
    this.valueFontSize = 24,
    this.labelFontSize = 12,
    this.activeColorStart = const Color(0xFF7B1FA2),
    this.activeColorEnd = const Color(0xFFE91E63),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.animationDuration = const Duration(milliseconds: 3000),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: gaugeSize,
      height: gaugeSize + 30,
      child: TweenAnimationBuilder<double>(
        // If isAnimate is false, it "starts" at the final value (no movement)
        tween: Tween<double>(
            begin: isAnimate ? 0.0 : value,
            end: value
        ),
        duration: isAnimate ? animationDuration : Duration.zero,
        curve: Curves.easeOutBack, // Gives a slight "bounce" to the dashes
        builder: (context, animatedValue, child) {
          return CustomPaint(
            painter: DashedGaugePainter(
              value: animatedValue, // Uses the moving value
              label: label,
              arcRadius: arcRadius,
              valueFontSize: valueFontSize,
              labelFontSize: labelFontSize,
              activeColorStart: activeColorStart,
              activeColorEnd: activeColorEnd,
              inactiveColor: inactiveColor,
            ),
          );
        },
      ),
    );
  }
}