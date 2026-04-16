import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/model/design_helper/tapered_needle_meter_painter.dart';

class TaperedNeedleMeter extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final String label;
  final bool isShowingInnerLine;
  final bool isAnimate;
  final Duration animationDuration;


  // Style Properties
  final double arcRadius;
  final double arcWidth;
  final List<Color> activeGradient;
  final Color backgroundArcColor; // "Cut of the clock color"
  final Color needleColor;
  final double labelFontSize;
  final double valueFontSize;

  const TaperedNeedleMeter({
    super.key,
    required this.value,
    this.minValue = 0,
    this.maxValue = 100,
    this.label = "MEMORY",
    this.arcRadius = 80,
    this.arcWidth = 22,
    this.isAnimate = true,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.activeGradient = const [Color(0xFF4A148C), Color(0xFFAD1457)],
    this.backgroundArcColor = const Color(0xFFEEEEEE),
    this.needleColor = const Color(0xFF424242),
    this.labelFontSize = 14,
    this.valueFontSize = 16,
    this.isShowingInnerLine = true


  });

  @override
  Widget build(BuildContext context) {
    // We calculate the widget size based on the arcRadius to keep it responsive
    final totalSize = (arcRadius + arcWidth) * 2;
    return TweenAnimationBuilder<double>(
      // Animates from 0 to the target value
      tween: Tween<double>(begin: 0, end: value),
      duration: isAnimate ? animationDuration : Duration.zero, // Adjust speed here
      curve: Curves.easeOutQuart, // Makes the needle "settle" smoothly
      builder: (context, animatedValue, child) {
        return CustomPaint(
          painter: TaperedNeedleMeterPainter(
            value: animatedValue, // Use the interpolated value
            min: 0,
            max: 100,
            label: label,
            arcRadius: arcRadius,
            arcWidth: arcWidth,
            activeGradient: activeGradient,
            bgArcColor: backgroundArcColor,
            needleColor: needleColor,
            labelFontSize: labelFontSize,
            valueSize: 12,
            isShowingInnerLine: isShowingInnerLine,
          ),
        );
      },
    );
    // return SizedBox(
    //   width: totalSize,
    //   height: totalSize + 40, // Extra height for the bottom label
    //   child: CustomPaint(
    //     painter: TaperedNeedleMeterPainter(
    //         value: value,
    //         min: minValue,
    //         max: maxValue,
    //         label: label,
    //         arcRadius: arcRadius,
    //         arcWidth: arcWidth,
    //         activeGradient: activeGradient,
    //         bgArcColor: backgroundArcColor,
    //         needleColor: needleColor,
    //         labelFontSize: labelFontSize,
    //         valueSize: valueFontSize,
    //         isShowingInnerLine: isShowingInnerLine!
    //     ),
    //   ),
    // );
  }
}
