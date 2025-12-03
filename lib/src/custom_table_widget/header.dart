

import 'package:report_data_table_2/src/custom_table_widget/sub_header.dart';

class Header {
  final String title;
  final double? width;
  final List<SubHeader> subHeaders;


  Header({required this.title, this.width, this.subHeaders = const []})
      : assert(subHeaders.isEmpty || width == null,
  'When using subHeaders, provide widths on subHeaders instead of header width');
}