import 'header.dart';
import 'custom_table_cell_data.dart';


class TableData {
  final List<Header> headers;
  final List<List<CustomTableCellData>> rows; // every inner list must have leafColumnsCount items

  TableData({required this.headers, required this.rows});
}