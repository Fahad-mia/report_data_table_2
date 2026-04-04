import 'package:flutter/material.dart';
import 'package:report_data_table_2/report_data_table_2.dart';
import 'package:report_data_table_2/src/custom_chart/custom_line_chart/widget/custom_line_chart.dart';

class DemoLineChart extends StatelessWidget {
  const DemoLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 1: Prepare the data points
    final lineData = [
      CustomLineDataModel(label: "Mon", value: 20, color: Colors.greenAccent),
      CustomLineDataModel(label: "Tue", value: 50, color: Colors.lightGreen),
      CustomLineDataModel(label: "Wed", value: 40, color: Colors.blue),
      CustomLineDataModel(label: "Thu", value: 80, color: Colors.black),
      CustomLineDataModel(label: "Fri", value: 60, color: Colors.green),
      CustomLineDataModel(label: "Sat", value: 90, color: Colors.teal),
      CustomLineDataModel(label: "Sun", value: 70, color: Colors.red),
      CustomLineDataModel(label: "Mon", value: 20, color: Colors.greenAccent),
      CustomLineDataModel(label: "Tue", value: 50, color: Colors.lightGreen),
      CustomLineDataModel(label: "Wed", value: 40, color: Colors.blue),
      CustomLineDataModel(label: "Thu", value: 80, color: Colors.black),
      CustomLineDataModel(label: "Fri", value: 60, color: Colors.green),
      CustomLineDataModel(label: "Sat", value: 20, color: Colors.teal),
      CustomLineDataModel(label: "Sun", value: 70, color: Colors.red),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Line Chart Demo")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weekly Revenue",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Step 2: Implementation
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: CustomLineChart(
                data: lineData,
                height: 250,
                pointSpacing: 70,       // Space between each day
                lineColor: Colors.blue, // The "Paint" color
                lineWidth: 3.0,         // Thickness of the line
                showDots: true,         // Show circles at data points
                axisColor: Colors.black12,
                labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}