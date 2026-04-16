import 'package:flutter/material.dart';
// Note: Ensure your import path for NeedleGaugePainter is correct
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/model/design_helper/needle_gauge_painter.dart';

class NeedleGaugeWidget extends StatelessWidget {
  final double value;
  final String label;
  final bool isAnimate;

  // Customization Properties
  final double gaugeSize;
  final double arcRadius;
  final double arcWidth;
  final double valueFontSize;
  final double labelFontSize;
  final Color needleColor;
  final List<Color> gradientColors;

  // Animation Properties
  final Duration animationDuration;
  final Curve animationCurve;

  const NeedleGaugeWidget({
    super.key,
    required this.value,
    this.label = "MEMORY",
    this.gaugeSize = 200,
    this.arcRadius = 70,
    this.isAnimate = true,
    this.arcWidth = 14,
    this.valueFontSize = 28,
    this.labelFontSize = 12,
    this.needleColor = const Color(0xFFE91E63),
    this.gradientColors = const [Color(0xFF6A1B9A), Color(0xFFE91E63)],
    this.animationDuration = const Duration(milliseconds: 3000),
    this.animationCurve = Curves.easeOutCubic, // Smooth deceleration
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: gaugeSize,
      height: gaugeSize + 20,
      child: TweenAnimationBuilder<double>(
        // This tells Flutter to animate from 0.0 to your target value
        tween: Tween<double>(begin: 0, end: value),
        duration: isAnimate ? animationDuration : Duration.zero,
        curve: animationCurve,
        builder: (context, animatedValue, child) {
          return CustomPaint(
            painter: NeedleGaugePainter(
              // Pass the animatedValue instead of the static value
              value: animatedValue,
              label: label,
              arcRadius: arcRadius,
              arcWidth: arcWidth,
              valueFontSize: valueFontSize,
              labelFontSize: labelFontSize,
              needleColor: needleColor,
              gradientColors: gradientColors,
            ),
          );
        },
      ),
    );
  }
}