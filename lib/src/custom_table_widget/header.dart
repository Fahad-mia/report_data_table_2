import 'package:flutter/material.dart';

import 'package:report_data_table_2/src/custom_table_widget/sub_header.dart';

class Header {
  final String title;
  final double? width;
  final Color? headerBGColor;
  final List<SubHeader> subHeaders;
  final TextStyle? headerTextStyle;
  final Alignment? alignment;

  Header({
    required this.title,
    this.width,
    this.subHeaders = const [],
    this.headerBGColor,
    this.headerTextStyle,
    this.alignment
  }) : assert(
         subHeaders.isEmpty || width == null,
         'When using subHeaders, provide widths on subHeaders instead of header width',
       );
}
