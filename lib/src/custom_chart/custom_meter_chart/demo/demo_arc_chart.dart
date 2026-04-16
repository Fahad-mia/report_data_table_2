import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/widget/dashed_gauge_widget.dart';
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/widget/needle_gauge_widget.dart';
import 'package:report_data_table_2/src/custom_chart/custom_meter_chart/widget/tapered_needle_meter.dart';


class DemoArcChart extends StatelessWidget {
  const DemoArcChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Memory Gauges Demo")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 30,
          children: [
            const DashedMeterWidget(
              value: 70,
              label: "sales",
              arcRadius: 50,
            ),
             NeedleGaugeWidget(value: 50),
            const TaperedNeedleMeter(
              value: 60,
              label: "STORAGE",
              arcRadius: 60,
              arcWidth: 20,
              activeGradient: [
                Color(0xFF4A148C), // Deep Purple
                Color(0xFFAD1457), // Magenta
              ],
              backgroundArcColor: Color(0xFFF5F5F5),
              // Light "Cut" color
              needleColor: Color(0xFF333333),
            ),



            // Re-use GradientArcWidget for the 4th style with different parameters
          ],
        ),
      ),
    );
  }
}
