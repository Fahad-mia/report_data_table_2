import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/model/design_helper/dashed_gauge_painter.dart';

class DashedGaugeWidget extends StatelessWidget {
  final double value;
  final String label;

  final double gaugeSize; // Total size of the widget
  final double arcRadius; // Size of the actual circle arc
  final double labelFontSize;
  final double valueFontSize;
  final Color activeColorStart;
  final Color activeColorEnd;
  final Color inactiveColor;

  const DashedGaugeWidget({
    super.key,
    required this.value,
    this.label = "MEMORY",
    this.gaugeSize = 69, // Defaulted to be smaller than before
    this.arcRadius = 90, // Control the "bigness" of the arc here
    this.valueFontSize = 24,
    this.labelFontSize = 12,
    this.activeColorStart = const Color(0xFF7B1FA2),
    this.activeColorEnd = const Color(0xFFE91E63),
    this.inactiveColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: gaugeSize,
      height: gaugeSize + 30, // Space for the bottom label
      child: CustomPaint(
        painter: DashedGaugePainter(
          value: value,
          label: label,
          arcRadius: arcRadius,
          valueFontSize: valueFontSize,
          labelFontSize: labelFontSize,
          activeColorStart: activeColorStart,
          activeColorEnd: activeColorEnd,
          inactiveColor: inactiveColor,
        ),
      ),
    );
  }
}
// class DashedGaugeWidget extends StatelessWidget {
//   final double value; // 0–100
//   final String label;
//
//   const DashedGaugeWidget({
//     super.key,
//     required this.value,
//     this.label = "MEMORY",
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 180,
//       height: 210, // extra space for label
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           /// ARC
//           Positioned(
//             top: 0,
//             child: CustomPaint(
//               size: const Size(180, 180),
//               painter: DashedGaugePainter(value),
//             ),
//           ),
//
//           /// VALUE (center of circle)
//           Positioned(
//             top: 65, // 👈 center align
//             child: Text(
//               "${value.toInt()}%",
//               style: const TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//
//           /// LABEL (below gauge)
//           Positioned(
//             top: 150,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.2,
//               ),
//             ),
//           ),
//
//           /// 00 (left bottom)
//           Positioned(
//             top: 150,
//             left: 240,
//             child: const Text(
//               "00",
//               style: TextStyle(fontSize: 10, color: Colors.grey),
//             ),
//           ),
//
//           /// 100 (right bottom)
//           Positioned(
//             top: 150,
//             right: 240,
//             child: const Text(
//               "100",
//               style: TextStyle(fontSize: 10, color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
