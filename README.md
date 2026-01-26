# report_data_table_2

A powerful and highly customizable Flutter data table widget built for **report-style layouts**,
featuring **fixed columns**, **multi-level headers**, **editable cells**, and **synchronized
scrolling**.

This package is ideal for enterprise dashboards, MIS reports, analytics tables, and complex data
presentation where Flutter’s default `DataTable` is not enough.

---

## ✨ Features

- 📌 Fixed (frozen) columns support
- 🧱 Multi-level headers with optional sub-headers
- ↔️ Horizontal & vertical scroll synchronization
- ✏️ Editable cells with built-in `TextField`
- 🎨 Per-cell customization
    - Background color
    - Text color & font size
    - Alignment
    - Border
- 🧩 Custom widget support inside cells
- 📐 Fully configurable layout
    - Header height
    - Sub-header height
    - Row height
    - Column width
    - Table height

---

## 📦 Installation

Add this dependency to your `pubspec.yaml`:

```yaml
dependencies:
  report_data_table_2: ^1.0.0
  ```

then run
**flutter pub get**

## Getting Started

```dart
   import 'package:report_data_table_2/report_data_table_2.dart';
   ```

## Usage

### Define headers

```dart

final headers = [
  Header(
    title: "Employee Name",
    width: 150,
    headerTextStyle: GoogleFonts.poppins(
      fontSize: TextFontSize.footnote,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryBlue,
    ),
    headerBGColor: AppColors.whiteColor,
    alignment: Alignment.center,
  ),
  Header(
    title: "Employee Info",
    headerBGColor: Colors.white,
    headerTextStyle: TextStyle(color: Colors.red, fontSize: 20),
    subHeaders: [
      //   SubHeader(title: "Name", width: 80),
      SubHeader(title: "Others",
          width: 120,
          subheaderTextStyle: TextStyle(color: Colors.green, fontSize: 20)),
    ],
  )
];

```

## Build the table rows.

```dart

final rows = [
  [
    CustomTableCellData(
      child: InkWell(
        onTap: () async {
        },
        child: Text(e.employeeCode.toString()),
      ),
      textColor: AppColors.blackColor,
      fontSize: TextFontSize.body,
      backgroundColor: AppColors.lightLavender,
      alignment: Alignment.center,
      border: Border.all(width: .9, color: AppColors.whiteColor),
    ),
    CustomTableCellData(text: 'John Doe'),
  ],
];
```
## Build Table.

```dart
@override
Widget build(BuildContext context) {
  final completeTable = TableData(
    headers: leaveListHeader,
    rows: tableRows,
  );

  return CustomTableWidget(
    data: completeTable,
    fixedColumns: 1,
    headerHeight: 40,
    subHeaderHeight: 0,    rowHeight: 50,
    defaultColumnWidth: 120,
    tableHeight: tableHeight,
  );
}
```

```Image```
![App Screenshot](https://github.com/Fahad-mia/report_data_table_2/blob/master/assets/images/leavelist.png)

## License

MIT License
