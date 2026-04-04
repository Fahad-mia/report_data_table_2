import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/model/custom_bar_data.dart';

class CustomBarChart extends StatefulWidget {
  final List<CustomBarData> data;
  final double height;
  final double width;
  final Color axisColor;
  final double barWidth;
  final double barGap;
  final double borderRadius;
  final TextStyle? labelStyle;
  final bool isInteractive;

  const CustomBarChart({
    super.key,
    required this.data,
    this.height = 300,
    this.width = double.infinity,
    this.axisColor = Colors.grey,
    this.barWidth = 30,
    this.barGap = 4,
    this.borderRadius = 4,
    this.labelStyle,
    this.isInteractive = false, // Default is false
  });

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  int? _activeIndex; // Tracks which bar is hovered/clicked

  @override
  Widget build(BuildContext context) {
    double maxValue = widget.data.map((e) => e.value).fold(0, (prev, e) => e > prev ? e : prev);
    if (maxValue <= 0) maxValue = 1.0;

    const double valueLabelHeight = 20.0;
    const double innerGap = 4.0;
    const double bottomLabelHeight = 25.0;
    const double dividerHeight = 1.0;
    const double outerSpacing = 12.0;

    final double totalChartArea = widget.height - bottomLabelHeight - outerSpacing - dividerHeight;
    final double maxPossibleBarHeight = totalChartArea - valueLabelHeight - innerGap;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. THE BARS & TOP LABELS
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(widget.data.length, (index) {
                  final item = widget.data[index];
                  final double barHeight = (item.value / maxValue) * maxPossibleBarHeight;
                  final bool isSelected = _activeIndex == index;

                  // Determine visibility logic
                  final bool showDetails = !widget.isInteractive || isSelected;

                  return InkWell(
                    onTap: () {
                      if (widget.isInteractive) {
                        setState(() => _activeIndex = index);
                      }
                    },
                    onHover: (hovering) {
                      if (widget.isInteractive) {
                        setState(() => _activeIndex = hovering ? index : null);
                      }
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: widget.barWidth + (widget.barGap * 2),
                      padding: EdgeInsets.symmetric(horizontal: widget.barGap),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Value Label
                          SizedBox(
                            height: valueLabelHeight,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: showDetails ? 1.0 : 0.0,
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    item.value.toStringAsFixed(0),
                                    style: widget.labelStyle ?? const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: innerGap),
                          // The Bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: barHeight.clamp(0, maxPossibleBarHeight),
                            width: widget.barWidth,
                            decoration: BoxDecoration(
                              color: isSelected ? item.color.withValues(alpha: 0.7) : item.color,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(widget.borderRadius),
                              ),
                              boxShadow: isSelected ? [BoxShadow(color: item.color.withValues(alpha: 0.3), blurRadius: 4, spreadRadius: 2)] : [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // 2. THE SOLID AXIS LINE
            SizedBox(height: outerSpacing / 2),
            Container(
              height: dividerHeight,
              width: (widget.barWidth + (widget.barGap * 2)) * widget.data.length,
              color: widget.axisColor,
            ),
            SizedBox(height: outerSpacing / 2),

            // 3. THE BOTTOM LABELS
            Row(
              children: List.generate(widget.data.length, (index) {
                final item = widget.data[index];
                final bool isSelected = _activeIndex == index;
                final bool showDetails = !widget.isInteractive || isSelected;

                return Container(
                  width: widget.barWidth + (widget.barGap * 2),
                  height: bottomLabelHeight,
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: showDetails ? 1.0 : 0.0,
                    child: Text(
                      item.label,
                      style: widget.labelStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}