import 'package:flutter/cupertino.dart';

class CustomTableCellData {
  final String? text;
  final Widget? child; // if you want provide custom widget
  final bool editable;
  final Alignment? alignment;
  final EdgeInsets padding;

  // visual customization
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final Border? border;

  CustomTableCellData({
    this.text,
    this.child,
    this.editable = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    this.backgroundColor,
    this.alignment,
    this.textColor,
    this.fontSize,
    this.border,
  });
}