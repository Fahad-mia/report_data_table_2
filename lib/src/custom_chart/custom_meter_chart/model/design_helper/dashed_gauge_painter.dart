import 'dart:math';

import 'package:flutter/material.dart';

class DashedGaugePainter extends CustomPainter {
  final double value;
  final String label;
  final double arcRadius;
  final double valueFontSize;
  final double labelFontSize;
  final TextStyle? labelTextStyle;
  final Color activeColorStart;
  final Color activeColorEnd;
  final Color inactiveColor;

  DashedGaugePainter({
    required this.value,
    required this.label,
    required this.arcRadius,
    required this.valueFontSize,
    required this.labelFontSize,
    this.labelTextStyle,
    required this.activeColorStart,
    required this.activeColorEnd,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);

    const totalTicks = 60;
    const startAngle = pi * 0.75;
    const sweepAngle = pi * 1.5;

    final activeTicks = (value.clamp(0, 100) / 100 * totalTicks).round();

    // 1. Draw Ticks
    for (int i = 0; i < totalTicks; i++) {
      final angle = startAngle + (i / totalTicks) * sweepAngle;
      final isActive = i < activeTicks;

      final tickLength = i % 5 == 0 ? 12.0 : 6.0;
      final strokeWidth = i % 5 == 0 ? 2.5 : 1.2;

      final paint = Paint()
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = isActive
            ? Color.lerp(activeColorStart, activeColorEnd, i / totalTicks)!
            : inactiveColor;

      final p1 = Offset(
        center.dx + (arcRadius - tickLength) * cos(angle),
        center.dy + (arcRadius - tickLength) * sin(angle),
      );
      final p2 = Offset(
        center.dx + arcRadius * cos(angle),
        center.dy + arcRadius * sin(angle),
      );

      canvas.drawLine(p1, p2, paint);
    }

    // 2. Center Value
    _drawText(
      canvas: canvas,
      text: "${value.toInt()}%",
      style: labelTextStyle ??
          TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
      centerOffset: center,
    );

    // 3. Bottom Label
    _drawText(
      canvas: canvas,
      text: label,
      style: TextStyle(
        fontSize: labelFontSize,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
        color: Colors.black,
      ),
      centerOffset: Offset(center.dx, center.dy + (arcRadius * 1.1)),
    );

    // 4. "00" and "100" Indicators
    final labelRadius = arcRadius + 15;

    _drawText(
      canvas: canvas,
      text: "00",
      style: const TextStyle(fontSize: 9, color: Colors.grey),
      centerOffset: Offset(
        center.dx + labelRadius * cos(startAngle),
        center.dy + labelRadius * sin(startAngle),
      ),
    );

    _drawText(
      canvas: canvas,
      text: "100",
      style: const TextStyle(fontSize: 9, color: Colors.grey),
      centerOffset: Offset(
        center.dx + labelRadius * cos(startAngle + sweepAngle),
        center.dy + labelRadius * sin(startAngle + sweepAngle),
      ),
    );
  }

  void _drawText({
    required Canvas canvas,
    required String text,
    required TextStyle style,
    required Offset centerOffset,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      centerOffset.dx - (textPainter.width / 2),
      centerOffset.dy - (textPainter.height / 2),
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(DashedGaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.arcRadius != arcRadius;
}
// class DashedGaugePainter extends CustomPainter {
//   final double value;
//
//   DashedGaugePainter(this.value);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = size.center(Offset.zero);
//     final radius = size.width / 2.2;
//
//     const totalTicks = 60;
//     const startAngle = pi * 0.75; // 135°
//     const sweepAngle = pi * 1.5;  // 270°
//
//     final activeTicks = (value / 100 * totalTicks).round();
//
//     for (int i = 0; i < totalTicks; i++) {
//       final angle = startAngle + (i / totalTicks) * sweepAngle;
//
//       final isActive = i < activeTicks;
//
//       final tickLength = i % 5 == 0 ? 14.0 : 8.0;
//       final strokeWidth = i % 5 == 0 ? 2.5 : 1.5;
//
//       final paint = Paint()
//         ..strokeWidth = strokeWidth
//         ..strokeCap = StrokeCap.round
//         ..color = isActive
//             ? Color.lerp(
//           const Color(0xFF7B1FA2), // purple
//           const Color(0xFFE91E63), // pink
//           i / totalTicks,
//         )!
//             : Colors.grey.shade300;
//
//       final p1 = Offset(
//         center.dx + (radius - tickLength) * cos(angle),
//         center.dy + (radius - tickLength) * sin(angle),
//       );
//
//       final p2 = Offset(
//         center.dx + radius * cos(angle),
//         center.dy + radius * sin(angle),
//       );
//
//       canvas.drawLine(p1, p2, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
