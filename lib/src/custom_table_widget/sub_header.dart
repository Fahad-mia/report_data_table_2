import 'package:flutter/material.dart';
class SubHeader {
  final String title;
  final double width; // required when using sub-headers
  final Color? subheaderBGColor;
  final TextStyle? subheaderTextStyle;

  SubHeader({
    required this.title,
    required this.width,
    this.subheaderBGColor,
    this.subheaderTextStyle,
  });
}
