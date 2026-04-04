import 'package:flutter/material.dart';

class CustomBarData {
  final String label;
  final double value;
  final Color color;

  CustomBarData({
    required this.label,
    required this.value,
    this.color = Colors.blue,
  });
}