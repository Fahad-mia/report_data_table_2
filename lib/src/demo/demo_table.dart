import 'package:flutter/material.dart';

import '../../report_data_table_2.dart';
import '../custom_table_widget/custom_table_widget.dart';

class DemoTable extends StatelessWidget {
  const DemoTable({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 1: Create headers
    final header = [
      Header(
        title: "Employee Info",
        headerBGColor: Colors.white,
        headerTextStyle: TextStyle(color: Colors.red, fontSize: 20),
        subHeaders: [
        //   SubHeader(title: "Name", width: 80),
          SubHeader(title: "Others", width: 120, subheaderTextStyle: TextStyle(color: Colors.green, fontSize: 20)),
        ],
      ),
      Header(
        title: "Sales Data",
        // subHeaders: [
        //   SubHeader(title: "Q1", width: 60),
        //   SubHeader(title: "Q2", width: 80),
        //   SubHeader(title: "Q3", width: 80),
        //   SubHeader(title: "Q4", width: 80),
        // ],
      ),
      Header(
        title: "Contract",
        width: 100, // no subheaders
      ),
      Header(
        title: "Address",
        width: 100, // no subheaders
      ),
    ];

    // Step 2: Generate 20 rows dynamically
    final List<List<CustomTableCellData>> rows = List.generate(20, (index) {
      // final isActive = index % 2 == 0;
      final employeeName = "Employee ${index + 1}";
      final department = index % 3 == 0
          ? "Sales"
          : index % 3 == 1
          ? "IT"
          : "HR";

      return [
        CustomTableCellData(
          text: employeeName,
          textColor: Colors.red,
        ),
        CustomTableCellData(text: department),
        CustomTableCellData(text: "${10000 + index * 100}"),
        CustomTableCellData(text: "${10500 + index * 100}")
        // CustomTableCellData(text: "${11000 + index * 100}"),
        // CustomTableCellData(text: "${11500 + index * 100}"),
        // CustomTableCellData(text: isActive ? "Active" : "Expired"),
        // CustomTableCellData(
        //   text: "Dhaka",
        //   textColor: Colors.blue,
        //   textAlign: TextAlign.right,
        // ),
      ];
    });

    // Step 3: Combine into a TableData object
    final tableData = TableData(headers: header, rows: rows);

    // Step 4: Use CustomDataTable widget
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomTableWidget(
          data: tableData,
          fixedColumns: 2, // Fix first column (Name)
          headerHeight: 52,
          subHeaderHeight: 44,
          rowHeight: 52,
          tableHeight: 600,
          defaultColumnWidth: 120,
        ),
      ),
    );
  }
}
