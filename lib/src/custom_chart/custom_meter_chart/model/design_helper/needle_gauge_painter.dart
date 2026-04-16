import 'dart:math';

import 'package:flutter/material.dart';

class NeedleGaugePainter extends CustomPainter {
  final double value;
  final String label;
  final double arcRadius;
  final double arcWidth;
  final double valueFontSize;
  final double labelFontSize;
  final TextStyle? labelTextStyle;
  final Color needleColor;
  final List<Color> gradientColors;

  NeedleGaugePainter({
    required this.value,
    required this.label,
    required this.arcRadius,
    required this.arcWidth,
    required this.valueFontSize,
    required this.labelFontSize,
    this.labelTextStyle,
    required this.needleColor,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const startAngle = pi * 0.75; // 135°
    const sweepAngle = pi * 1.5; // 270°

    final currentAngle = startAngle + (value.clamp(0, 100) / 100) * sweepAngle;

    // 1. Draw Background Arc
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey.shade300;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // 2. Draw Active Gradient Arc
    final rect = Rect.fromCircle(center: center, radius: arcRadius);
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: gradientColors,
    );

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);

    canvas.drawArc(
      rect,
      startAngle,
      (value.clamp(0, 100) / 100) * sweepAngle,
      false,
      activePaint,
    );

    // 3. Draw Needle
    final needleLength = arcRadius - 5;
    final needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + needleLength * cos(currentAngle),
      center.dy + needleLength * sin(currentAngle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // 4. Center Dot
    final dotPaint = Paint()..color = needleColor;
    canvas.drawCircle(center, 6, dotPaint);

    // 5. Draw Value Text (Positioned slightly above the center)
    _drawText(
      canvas: canvas,
      text: "${value.toInt()}%",
      style: TextStyle(
        fontSize: valueFontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      centerOffset: Offset(center.dx, center.dy - (arcRadius * -0.3)),
    );

    // 6. Draw Label (Positioned perfectly in the middle of the bottom gap)
    _drawText(
      canvas: canvas,
      text: label,
      style: labelTextStyle ??
          TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.grey,
          ),
      // 0.75 of radius is usually the sweet spot for the 270 degree gap
      centerOffset: Offset(center.dx, center.dy + (arcRadius * 0.96)),
    );
  }

  /// Helper to draw text centered at a specific offset
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
  bool shouldRepaint(NeedleGaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.arcRadius != arcRadius ||
        oldDelegate.label != label;
  }
}
