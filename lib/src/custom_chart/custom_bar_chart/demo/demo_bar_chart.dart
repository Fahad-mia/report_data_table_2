import 'package:flutter/material.dart';
import 'package:report_data_table_2/report_data_table_2.dart';

class DemoBarChart extends StatefulWidget {
  const DemoBarChart({super.key});

  @override
  State<DemoBarChart> createState() => _DemoBarChartState();
}

class _DemoBarChartState extends State<DemoBarChart> {
  final List<CustomBarData> chartData = [
    CustomBarData(
      label: 'Jan',
      value: 450,
      color: Colors.blue.shade300,
    ),
    CustomBarData(
      label: 'Feb',
      value: 620,
      color: Colors.blue.shade300,
    ),
    CustomBarData(
      label: 'Mar',
      value: 890,
      color: Colors.blue.shade600, // Highlighted peak month
    ),
    CustomBarData(
      label: 'Apr',
      value: 550,
      color: Colors.blue.shade300,
    ),
    CustomBarData(
      label: 'May',
      value: 710,
      color: Colors.blue.shade300,
    ),
    CustomBarData(
      label: 'Jun',
      value: 480,
      color: Colors.blue.shade300,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CustomBarChart(
                  data: chartData,
                  height: 200,
                  barWidth: 45,
                  barGap: 20,
                  borderRadius: 15,
                  isInteractive: false,
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
