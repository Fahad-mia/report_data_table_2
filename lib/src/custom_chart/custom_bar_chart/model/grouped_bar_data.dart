import 'package:flutter/material.dart';

class GroupedBarData {
  final String label;
  final double target;
  final double actual;
  final double percentage;
  // Optional custom colors per data point
  final Color? targetColor;
  final Color? actualColor;
  final Color? dotColor;

  GroupedBarData({
    required this.label,
    required this.target,
    required this.actual,
    required this.percentage,
    this.targetColor,
    this.actualColor,
    this.dotColor,
  });
}