import 'package:flutter/material.dart';
import 'package:report_data_table_2/report_data_table_2.dart';

class CustomLineChart extends StatefulWidget {
  final List<CustomLineDataModel> data;
  final double height;
  final double pointSpacing;
  final Color lineColor;
  final double lineWidth;
  final bool showDots;
  final Color axisColor;
  final TextStyle? labelStyle;
  final int yAxisDivisions;

  const CustomLineChart({
    super.key,
    required this.data,
    this.height = 300,
    this.pointSpacing = 60,
    this.lineColor = Colors.blue,
    this.lineWidth = 2.0,
    this.showDots = true,
    this.axisColor = Colors.grey,
    this.labelStyle,
    this.yAxisDivisions = 5,
  });

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    // --- NEW: Calculate both Max and Min Values ---
    double maxValue = widget.data.map((e) => e.value).fold(0.0, (prev, e) => e > prev ? e : prev);
    double minValue = widget.data.map((e) => e.value).fold(0.0, (prev, e) => e < prev ? e : prev);

    // Ensure the chart at least spans a visible range if all values are 0
    if (maxValue == minValue) {
      maxValue += 1;
      minValue -= 1;
    }

    final double valueRange = maxValue - minValue;

    const double yAxisWidth = 50.0;
    const double bottomLabelHeight = 30.0;
    const double horizontalPadding = 20.0;

    const double topChartPadding = 45.0;
    const double bottomChartPadding = 15.0;

    final double chartDrawingHeight = widget.height - bottomLabelHeight - 20;
    final double actualChartHeight = chartDrawingHeight - topChartPadding - bottomChartPadding;

    final double chartContentWidth = widget.pointSpacing * (widget.data.length - 1);
    final double totalScrollWidth = chartContentWidth + (horizontalPadding * 2);

    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          // 1. FIXED Y-AXIS
          Container(
            width: yAxisWidth,
            height: chartDrawingHeight,
            margin: const EdgeInsets.only(bottom: bottomLabelHeight + 20),
            padding: const EdgeInsets.only(top: topChartPadding, bottom: bottomChartPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.yAxisDivisions + 1, (index) {
                // --- NEW: Calculate Y-Axis label relative to min and max ---
                double val = maxValue - (index * (valueRange / widget.yAxisDivisions));
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(val.toStringAsFixed(0),
                      style: widget.labelStyle ?? const TextStyle(fontSize: 10)),
                );
              }),
            ),
          ),

          // 2. SCROLLABLE CHART
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      final double localX = details.localPosition.dx - horizontalPadding;
                      int index = (localX / widget.pointSpacing).round();
                      if (index >= 0 && index < widget.data.length) {
                        setState(() => _selectedIndex = (_selectedIndex == index ? null : index));
                      }
                    },
                    child: Container(
                      height: chartDrawingHeight,
                      width: totalScrollWidth,
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        top: topChartPadding,
                        bottom: bottomChartPadding,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Grid Lines
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                                widget.yAxisDivisions + 1,
                                    (i) => Container(
                                    height: 0.5,
                                    width: chartContentWidth,
                                    color: widget.axisColor.withOpacity(0.2))),
                          ),

                          // Vertical Indicator Bar
                          if (_selectedIndex != null)
                            Positioned(
                              left: _selectedIndex! * widget.pointSpacing,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                  width: 1,
                                  color: widget.lineColor.withOpacity(0.3)),
                            ),

                          // The Line Painter
                          CustomPaint(
                            size: Size(chartContentWidth, actualChartHeight),
                            painter: LineDrawerHelper(
                              data: widget.data,
                              maxValue: maxValue,
                              minValue: minValue, // Passed new minValue
                              lineColor: widget.lineColor,
                              lineWidth: widget.lineWidth,
                              showDots: widget.showDots,
                              selectedIndex: _selectedIndex,
                            ),
                          ),

                          // Value Tooltip
                          if (_selectedIndex != null)
                            Positioned(
                              left: (_selectedIndex! * widget.pointSpacing) - 20,
                              // --- NEW: Calculate tooltip top relative to range ---
                              top: (1 - ((widget.data[_selectedIndex!].value - minValue) / valueRange)) * actualChartHeight - 35,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: widget.data[_selectedIndex!].color ?? widget.lineColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  widget.data[_selectedIndex!].value.toStringAsFixed(0),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Horizontal Axis & Labels
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                    height: 1,
                    width: chartContentWidth,
                    color: widget.axisColor,
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: totalScrollWidth,
                    height: bottomLabelHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: List.generate(widget.data.length, (index) {
                          return Positioned(
                            left: (index * widget.pointSpacing) - (widget.pointSpacing / 2),
                            width: widget.pointSpacing,
                            child: Text(
                              widget.data[index].label,
                              style: widget.labelStyle?.copyWith(
                                fontWeight: _selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}