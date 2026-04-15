import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/model/grouped_bar_data.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/widget/custom_grouped_bar_chart.dart';

class DemoGroupBarChart extends StatelessWidget {
  const DemoGroupBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 1: Prepare user-defined data
    final advancedChartData = [
      GroupedBarData(
        label: "JAN",
        target: 64.78,
        actual: 72.75,
        percentage: 112,
        // Custom colors for January only
        targetColor: Colors.orange.shade300,
        actualColor: Colors.orange.shade700,
        // dotColor: Colors.deepOrange,
      ),
      GroupedBarData(label: "FEB", target: 63.72, actual: 73.82, percentage: 81),
      GroupedBarData(label: "MAR", target: 70.54, actual: 62.57, percentage: 117),
      GroupedBarData(label: "APR", target: 110.93, actual: 55.76, percentage: 50),
      GroupedBarData(label: "MAY", target: 111.10, actual: 54.64, percentage: 49),
      GroupedBarData(label: "JUN", target: 101.20, actual: 80.24, percentage: 79),
      GroupedBarData(label: "JUL", target: 75.83, actual: 70.06, percentage: 95),
      GroupedBarData(label: "AUG", target: 76.24, actual: 69.90, percentage: 91),
      GroupedBarData(label: "SEP", target: 71.71, actual: 68.41, percentage: 96),
      GroupedBarData(label: "OCT", target: 71.71, actual: 53.41, percentage: 75),
      GroupedBarData(label: "NOV", target: 69.71, actual: 57.41, percentage: 82),
      GroupedBarData(label: "DEC", target: 70.71, actual: 58.41, percentage: 83),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Chart Variants Demo")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("1. New Complex Grouped Chart",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // HOW TO USE THE NEW CHART:
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomGroupedBarChart(
                  data: advancedChartData,
                  groupWidth: 80,
                  showDots: true,
                  showLine: true,
                  firstBarText: "Current Year",
                  secondBarText: "Previous Year",
                  targetColor: const Color(0xFFFFC000),
                  actualColor: const Color(0xFF00B050),
                  percentColor: const Color(0xFF4472C4),
                  height: 350,
                  maxPrimaryValue: 350,
                  maxSecondaryValue: 120,
                ),
              ),

              const SizedBox(height: 40),

              const Text("2. Existing Classic Chart",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

