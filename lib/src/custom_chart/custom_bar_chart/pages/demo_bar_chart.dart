import 'package:flutter/material.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/model/custom_bar_data.dart';
import 'package:report_data_table_2/src/custom_chart/custom_bar_chart/pages/custom_bar_chart.dart';

class DemoBarChart extends StatelessWidget {
  const DemoBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 1: Prepare user-defined data
    final chartData = [
      CustomBarData(label: "Jan", value: 45, color: Colors.blueAccent),
      CustomBarData(label: "Feb", value: 90, color: Colors.redAccent),
      CustomBarData(label: "Mar", value: 65, color: Colors.orangeAccent),
      CustomBarData(label: "Apr", value: 120, color: Colors.greenAccent),
      CustomBarData(label: "May", value: 80, color: Colors.purpleAccent),
      CustomBarData(label: "Jun", value: 30, color: Colors.tealAccent),
      CustomBarData(label: "Mar", value: 65, color: Colors.orangeAccent),
      CustomBarData(label: "Apr", value: 120, color: Colors.greenAccent),
      CustomBarData(label: "May", value: 80, color: Colors.purpleAccent),
      CustomBarData(label: "Jun", value: 30, color: Colors.tealAccent),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Custom Bar Chart Demo")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Monthly Performance",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Step 2: Use the CustomBarChart with user-defined properties
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CustomBarChart(
                  data: chartData,
                  height: 200,
                  barWidth: 45,
                  borderRadius: 15,
                  axisColor: Colors.greenAccent,
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 40),
              const Text("Chart Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              const Text(
                  "• Built using raw Containers\n• Fully responsive width\n• Animated on data load"),
            ],
          ),
        ),
      ),
    );
  }
}
