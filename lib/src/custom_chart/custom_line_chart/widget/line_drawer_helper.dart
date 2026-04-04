import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_line_chart/model/custom_line_data_model.dart';

class LineDrawerHelper extends CustomPainter {
  final List<CustomLineDataModel> data;
  final double maxValue;
  final Color lineColor;
  final double lineWidth;
  final bool showDots;
  final int? selectedIndex;

  LineDrawerHelper({
    required this.data,
    required this.maxValue,
    required this.lineColor,
    required this.lineWidth,
    required this.showDots,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final double stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      // Calculate coordinates
      double x = i * stepX;
      double y = size.height - (data[i].value / maxValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw the line
    canvas.drawPath(path, paint);

    // Inside LineDrawerHelper.paint()...
    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      double y = size.height - (data[i].value / maxValue * size.height);

      if (showDots) {
        // If selected, draw a bigger circle or a ring around the dot
        if (i == selectedIndex) {
          canvas.drawCircle(Offset(x, y), lineWidth * 3,
              Paint()..color = lineColor.withOpacity(0.2));
        }
        canvas.drawCircle(
            Offset(x, y), lineWidth * 1.5, Paint()..color = lineColor);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
