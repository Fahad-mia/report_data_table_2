import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/demo/demo_bar_chart.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/demo/demo_group_bar_chart.dart';
import 'package:report_data_table_2/src/custom_chart/custom_line_chart/demo/demo_line_chart.dart';
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/demo/demo_arc_chart.dart';
import 'package:report_data_table_2/src/demo/demo_table.dart'; // your package export

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Report Data Table Example',
      home: Scaffold(
        appBar: AppBar(title: const Text("Report Table Demo")),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: DemoArcChart(), // your demo widget
        ),

      ),
    );
  }
}
