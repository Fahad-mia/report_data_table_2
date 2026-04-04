import 'package:flutter/material.dart';
class CustomLineDataModel {
  final String label;
  final double value;
  final Color? color; // Added this

  CustomLineDataModel({
    required this.label,
    required this.value,
    this.color, // Optional
  });
}