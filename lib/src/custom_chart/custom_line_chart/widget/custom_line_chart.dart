import 'package:flutter/material.dart';
import 'package:report_data_table_2/report_data_table_2.dart';

class CustomLineChart extends StatefulWidget {
  final List<CustomLineDataModel> data;
  final double height;
  final double? chartWidth; // NEW: Optional fixed width
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
    this.chartWidth, // Initialize here
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
    // 1. DATA BOUNDS (Fixes the undefined name errors)
    final values = widget.data.map((e) => e.value).toList();

    // Using fold to handle the list safely
    double maxValue = values.fold(0.0, (prev, e) => e > prev ? e : prev);
    double minValue = values.fold(0.0, (prev, e) => e < prev ? e : prev);

    if (maxValue == minValue) {
      maxValue += 1;
      minValue -= 1;
    }
    final double valueRange = maxValue - minValue;

    // 2. UI DIMENSIONS
    const double yAxisWidth = 50.0;
    const double labelSpace = 30.0;
    const double sidePadding = 20.0;
    const double topPadding = 45.0;
    const double bottomPadding = 10.0;

    // 3. CHART HEIGHT CALCULATIONS
    final double totalAreaHeight = widget.height - labelSpace - 20;
    final double actualDrawingHeight = totalAreaHeight - topPadding - bottomPadding;

    // 4. CHART WIDTH CALCULATIONS
    // Use widget.chartWidth if provided, otherwise calculate based on spacing
    final double contentWidth = widget.chartWidth ?? (widget.pointSpacing * (widget.data.length - 1));

    // effectiveSpacing is used to find exactly where dots go on the X-axis
    final double effectiveSpacing = widget.chartWidth != null
        ? (contentWidth / (widget.data.length - 1))
        : widget.pointSpacing;

    final double totalScrollWidth = contentWidth + (sidePadding * 2);

    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          // --- 1. FIXED Y-AXIS ---
          Container(
            width: yAxisWidth,
            height: totalAreaHeight,
            margin: const EdgeInsets.only(bottom: labelSpace + 20),
            padding: const EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.yAxisDivisions + 1, (index) {
                double val = maxValue - (index * (valueRange / widget.yAxisDivisions));
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(val.toStringAsFixed(0),
                      style: widget.labelStyle ?? const TextStyle(fontSize: 10)),
                );
              }),
            ),
          ),

          // --- 2. SCROLLABLE CHART ---
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      final double localX = details.localPosition.dx - sidePadding;
                      int index = (localX / effectiveSpacing).round();
                      if (index >= 0 && index < widget.data.length) {
                        setState(() => _selectedIndex = (_selectedIndex == index ? null : index));
                      }
                    },
                    child: Container(
                      height: totalAreaHeight,
                      width: totalScrollWidth,
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                        left: sidePadding,
                        right: sidePadding,
                        top: topPadding,
                        bottom: bottomPadding,
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
                                    width: contentWidth,
                                    color: widget.axisColor.withOpacity(0.2))),
                          ),

                          // Vertical Indicator Bar
                          if (_selectedIndex != null)
                            Positioned(
                              left: _selectedIndex! * effectiveSpacing,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                  width: 1,
                                  color: widget.lineColor.withOpacity(0.3)),
                            ),

                          // The Line Painter
                          CustomPaint(
                            size: Size(contentWidth, actualDrawingHeight),
                            painter: LineDrawerHelper(
                              data: widget.data,
                              maxValue: maxValue,
                              minValue: minValue,
                              lineColor: widget.lineColor,
                              lineWidth: widget.lineWidth,
                              showDots: widget.showDots,
                              selectedIndex: _selectedIndex,
                            ),
                          ),

                          // Value Tooltip
                          if (_selectedIndex != null)
                            Positioned(
                              left: (_selectedIndex! * effectiveSpacing) - 20,
                              top: (1 - ((widget.data[_selectedIndex!].value - minValue) / valueRange)) * actualDrawingHeight - 35,
                              child: _buildTooltip(),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Horizontal Axis Labels
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: sidePadding),
                    height: 1,
                    width: contentWidth,
                    color: widget.axisColor,
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: totalScrollWidth,
                    height: labelSpace,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: sidePadding),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: List.generate(widget.data.length, (index) {
                          return Positioned(
                            left: (index * effectiveSpacing) - (effectiveSpacing / 2),
                            width: effectiveSpacing,
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

  Widget _buildTooltip() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.data[_selectedIndex!].color ?? widget.lineColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        widget.data[_selectedIndex!].value.toStringAsFixed(0),
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}