import 'dart:math';

import 'package:flutter/material.dart';

class TaperedNeedleMeterPainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final String label;
  final double arcRadius;
  final double arcWidth;
  final List<Color> activeGradient;
  final Color bgArcColor;
  final Color needleColor;
  final double labelFontSize;
  final TextStyle? labelTextStyle;
  final double valueSize;
  final bool isShowingInnerLine;

  TaperedNeedleMeterPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.arcRadius,
    required this.arcWidth,
    required this.activeGradient,
    required this.bgArcColor,
    required this.needleColor,
    required this.labelFontSize,
    this.labelTextStyle,
    required this.valueSize,
    this.isShowingInnerLine = true,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    const startAngle = pi * 0.75; // 135 degrees
    const sweepAngle = pi * 1.5; // 270 degrees

    // Normalize value to 0.0 - 1.0 based on min/max range
    final double normalizedValue =
    ((value - min) / (max - min)).clamp(0.0, 1.0);
    final currentAngle = startAngle + (normalizedValue * sweepAngle);

    // 1. Draw Background Arc
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth
      ..color = bgArcColor
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );


// 2. Draw Dotted Inner Line (Condition Added Here)
    if (isShowingInnerLine) {
      final dottedPaint = Paint()
        ..color = Colors.grey.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      final dottedRadius = arcRadius - arcWidth - 5;
      const int dashCount = 50;
      for (int i = 0; i < dashCount; i++) {
        double angle = startAngle + (i / dashCount) * sweepAngle;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: dottedRadius),
          angle,
          (sweepAngle / dashCount) * 0.4, // Dash length
          false,
          dottedPaint,
        );
      }
    }
    // 3. Draw Active Gradient Arc
    final rect = Rect.fromCircle(center: center, radius: arcRadius);
    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth
      ..strokeCap = StrokeCap.butt
      ..shader = SweepGradient(
        colors: activeGradient,
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        transform: GradientRotation(startAngle),
      ).createShader(rect);

    canvas.drawArc(
      rect,
      startAngle,
      normalizedValue * sweepAngle,
      false,
      activePaint,
    );

    // 4. Draw Needle (Triangular shape like the image)
    final needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;

    final Path needlePath = Path();
    final double needleTipLength = arcRadius + 5;
    final double needleBaseWidth = 8;

    // Calculate points for a sharp tapered needle
    Offset tip = Offset(center.dx + needleTipLength * cos(currentAngle),
        center.dy + needleTipLength * sin(currentAngle));
    Offset baseLeft = Offset(
        center.dx + needleBaseWidth * cos(currentAngle - pi / 2),
        center.dy + needleBaseWidth * sin(currentAngle - pi / 2));
    Offset baseRight = Offset(
        center.dx + needleBaseWidth * cos(currentAngle + pi / 2),
        center.dy + needleBaseWidth * sin(currentAngle + pi / 2));

    needlePath.moveTo(baseLeft.dx, baseLeft.dy);
    needlePath.lineTo(tip.dx, tip.dy);
    needlePath.lineTo(baseRight.dx, baseRight.dy);
    needlePath.close();
    canvas.drawPath(needlePath, needlePaint);

    // 5. Center Pivot Dot
    canvas.drawCircle(center, 8, needlePaint);
    canvas.drawCircle(center, 3, Paint()..color = Colors.white);

    // 6. Draw Value Text on the Arc (White number inside the purple area)
    // Only draw if value > 0 for visibility
    if (normalizedValue > 0.05) {
      final double textAngle = startAngle + (normalizedValue * sweepAngle) / 2;
      _drawText(
        canvas: canvas,
        text: value.toInt().toString(),
        style: TextStyle(
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        centerOffset: Offset(
          center.dx + arcRadius * cos(textAngle),
          center.dy + arcRadius * sin(textAngle),
        ),
      );
    }

    // 7. Draw Range Labels (00 and 100)
    final double labelRadius = arcRadius - 30;
    final labelStyle = TextStyle(
        fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold);

    _drawText(
      canvas: canvas,
      text: min.toInt().toString().padLeft(2, '0'),
      style: labelStyle,
      centerOffset: Offset(center.dx + labelRadius * cos(startAngle + 0.2),
          center.dy + labelRadius * sin(startAngle + 0.2)),
    );

    _drawText(
      canvas: canvas,
      text: max.toInt().toString(),
      style: labelStyle,
      centerOffset: Offset(
          center.dx + labelRadius * cos(startAngle + sweepAngle - 0.2),
          center.dy + labelRadius * sin(startAngle + sweepAngle - 0.2)),
    );

    // 8. Bottom Label (MEMORY)
    _drawText(
      canvas: canvas,
      text: label,
      style: labelTextStyle ??
          TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.w900,
              color: needleColor,
              letterSpacing: 1.5),
      centerOffset: Offset(center.dx, center.dy + arcRadius + 20),
    );
  }

  void _drawText(
      {required Canvas canvas,
        required String text,
        required TextStyle style,
        required Offset centerOffset}) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
        canvas,
        Offset(centerOffset.dx - textPainter.width / 2,
            centerOffset.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant TaperedNeedleMeterPainter oldDelegate) => true;
}
