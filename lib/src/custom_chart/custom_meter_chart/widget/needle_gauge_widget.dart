
import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/model/design_helper/needle_gauge_painter.dart';

class NeedleGaugeWidget extends StatelessWidget {
  final double value;
  final String label;

  // Customization Properties
  final double gaugeSize;      // Total size of the widget
  final double arcRadius;      // Size of the background arc
  final double arcWidth;       // Thickness of the arc
  final double valueFontSize;
  final double labelFontSize;
  final Color needleColor;
  final List<Color> gradientColors;

  const NeedleGaugeWidget({
    super.key,
    required this.value,
    this.label = "MEMORY",
    this.gaugeSize = 200,
    this.arcRadius = 70,       // Adjust this to change the arc size
    this.arcWidth = 14,
    this.valueFontSize = 28,
    this.labelFontSize = 12,
    this.needleColor = const Color(0xFFE91E63),
    this.gradientColors = const [Color(0xFF6A1B9A), Color(0xFFE91E63)],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: gaugeSize,
      height: gaugeSize + 20,
      child: CustomPaint(
        painter: NeedleGaugePainter(
          value: value,
          label: label,
          arcRadius: arcRadius,
          arcWidth: arcWidth,
          valueFontSize: valueFontSize,
          labelFontSize: labelFontSize,
          needleColor: needleColor,
          gradientColors: gradientColors,
        ),
      ),
    );
  }
}

