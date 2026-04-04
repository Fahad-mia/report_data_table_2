import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_line_chart/model/custom_line_data_model.dart';

class LineDrawerHelper extends CustomPainter {
  final List<CustomLineDataModel> data;
  final double maxValue;
  final double minValue; // Added minValue
  final Color lineColor;
  final double lineWidth;
  final bool showDots;
  final int? selectedIndex;

  LineDrawerHelper({
    required this.data,
    required this.maxValue,
    required this.minValue, // Added minValue
    required this.lineColor,
    required this.lineWidth,
    required this.showDots,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final double range = maxValue - minValue; // Calculate range

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      // --- NEW: Calculate Y coordinate based on total range and minimum value ---
      double y = size.height - ((data[i].value - minValue) / range * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw the line
    canvas.drawPath(path, paint);

    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      double y = size.height - ((data[i].value - minValue) / range * size.height);

      if (showDots) {
        final Color dotColor = data[i].color ?? lineColor;

        if (i == selectedIndex) {
          canvas.drawCircle(
            Offset(x, y),
            lineWidth * 3,
            Paint()..color = dotColor.withOpacity(0.2),
          );
        }

        canvas.drawCircle(
          Offset(x, y),
          lineWidth * 1.5,
          Paint()..color = dotColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}