import 'package:flutter/material.dart';
import '../../report_data_table_2.dart';
import 'column_leaf.dart';

class CustomTableWidget extends StatefulWidget {
  final TableData data;
  final int fixedColumns;
  final double headerHeight;
  final double subHeaderHeight;
  final double rowHeight;
  final double defaultColumnWidth;
  final double? tableHeight;

  const CustomTableWidget({
    Key? key,
    required this.data,
    this.fixedColumns = 0,
    this.headerHeight = 52,
    this.subHeaderHeight = 44,
    this.rowHeight = 52,
    this.defaultColumnWidth = 120,
    this.tableHeight,
  }) : super(key: key);

  @override
  State<CustomTableWidget> createState() => _CustomTableWidgetState();
}

class _CustomTableWidgetState extends State<CustomTableWidget> {
  late List<LeafColumn> _leafColumns;

  final _leftVerticalScroll = ScrollController();
  final _rightVerticalScroll = ScrollController();
  final _rightHorizontalScroll = ScrollController();
  final _headerHorizontalScroll = ScrollController();

  final Map<String, TextEditingController> _editingControllers = {};

  bool _isSyncingVertical = false;
  bool _isSyncingHorizontal = false;

  @override
  void initState() {
    super.initState();
    _flattenHeaders();

    _leftVerticalScroll.addListener(_syncVerticalLeft);
    _rightVerticalScroll.addListener(_syncVerticalRight);
    _rightHorizontalScroll.addListener(_syncBodyHorizontal);
    _headerHorizontalScroll.addListener(_syncHeaderHorizontal);
  }

  // ---------- SCROLL SYNC ----------
  void _syncVerticalLeft() {
    if (_isSyncingVertical) return;
    _isSyncingVertical = true;
    _rightVerticalScroll.jumpTo(_leftVerticalScroll.offset);
    _isSyncingVertical = false;
  }

  void _syncVerticalRight() {
    if (_isSyncingVertical) return;
    _isSyncingVertical = true;
    _leftVerticalScroll.jumpTo(_rightVerticalScroll.offset);
    _isSyncingVertical = false;
  }

  void _syncBodyHorizontal() {
    if (_isSyncingHorizontal) return;
    _isSyncingHorizontal = true;
    _headerHorizontalScroll.jumpTo(_rightHorizontalScroll.offset);
    _isSyncingHorizontal = false;
  }

  void _syncHeaderHorizontal() {
    if (_isSyncingHorizontal) return;
    _isSyncingHorizontal = true;
    _rightHorizontalScroll.jumpTo(_headerHorizontalScroll.offset);
    _isSyncingHorizontal = false;
  }

  // ---------- HEADER FLATTENING ----------
  void _flattenHeaders() {
    _leafColumns = [];

    for (final h in widget.data.headers) {
      if (h.subHeaders.isEmpty) {
        // Treat as a single header with no subheader
        _leafColumns.add(
          LeafColumn(h.title, '', h.width ?? widget.defaultColumnWidth),
        );
      } else {
        for (final s in h.subHeaders) {
          _leafColumns.add(LeafColumn(h.title, s.title, s.width));
        }
      }
    }
  }

  @override
  void didUpdateWidget(CustomTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.headers != widget.data.headers) {
      _flattenHeaders();
    }
  }

  @override
  void dispose() {
    _leftVerticalScroll.dispose();
    _rightVerticalScroll.dispose();
    _rightHorizontalScroll.dispose();
    _headerHorizontalScroll.dispose();
    for (final c in _editingControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------- UTILS ----------
  Widget _buildCell({
    required double width,
    required double height,
    required Widget child,
    Color? bg,
    Border? border,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg ?? Colors.transparent,
        border: border ?? Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: child,
    );
  }

  Widget _cellFromData(int rowIndex, int colIndex) {
    final cell = widget.data.rows[rowIndex][colIndex];
    if (cell.child != null) return cell.child!;

    final key = '$rowIndex \_$colIndex';
    if (cell.editable) {
      final controller = _editingControllers.putIfAbsent(
        key,
        () => TextEditingController(text: cell.text ?? ''),
      );
      return TextField(
        controller: controller,
        textAlign: cell.textAlign,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4), // optional rounding
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          isDense: true,
        ),

        style: TextStyle(color: cell.textColor),
      );
    }

    return Text(
      cell.text ?? '',
      textAlign: cell.textAlign,
      style: TextStyle(color: cell.textColor, fontSize: cell.fontSize),
    );
  }

  // ---------- HEADER BUILDERS ----------
  Widget _buildHeaderArea({required int fixed, required bool isLeft}) {
    final columns = isLeft
        ? _leafColumns.sublist(0, fixed)
        : _leafColumns.sublist(fixed);
    final scrollController = isLeft ? null : _headerHorizontalScroll;

    // Determine if this section has any meaningful subheaders
    final headersInSection = widget.data.headers.where((h) {
      return _leafColumns
          .where((c) => c.headerTitle == h.title)
          .any((c) => columns.contains(c));
    }).toList();

    final sectionHasSubHeaders = headersInSection.any((h) {
      return h.subHeaders.isNotEmpty;
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Row(
        children: headersInSection.map((h) {
          // Columns that belong to this header in this section
          final related = _leafColumns
              .where((c) => c.headerTitle == h.title && columns.contains(c))
              .toList();
          final totalWidth = related.fold(0.0, (sum, c) => sum + c.width);

          final hasMeaningfulSubHeaders =
              h.subHeaders.isNotEmpty &&
              h.subHeaders.map((s) => s.title).toSet().length > 1;

          // If header has meaningful subheaders, split top & sub rows
          final topHeight = hasMeaningfulSubHeaders && sectionHasSubHeaders
              ? widget.headerHeight
              : widget.headerHeight + widget.subHeaderHeight;

          return Column(
            children: [
              _buildCell(
                width: totalWidth,
                height: topHeight,
                child: Center(
                  child: Text(
                    h.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                bg: h.headerBGColor ?? Colors.grey.shade100,
              ),
              if (hasMeaningfulSubHeaders && sectionHasSubHeaders)
                Row(
                  children: related.map((c) {
                    // find corresponding SubHeader model
                    final sub = h.subHeaders.firstWhere(
                          (s) => s.title == c.title,
                      orElse: () => SubHeader(title: c.title, width: c.width),
                    );

                    return _buildCell(
                      width: c.width,
                      height: widget.subHeaderHeight,
                      child: Center(
                        child: Text(
                          c.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      bg: sub.subheaderBGColor ?? h.headerBGColor,
                    );
                  }).toList(),
                ),

            ],
          );
        }).toList(),
      ),
    );
  }

  // ---------- BODY BUILDER ----------
  Widget _buildBodyPart({required int fixed, required bool isLeft}) {
    final columns = isLeft
        ? _leafColumns.sublist(0, fixed)
        : _leafColumns.sublist(fixed);
    final widths = columns.map((c) => c.width).toList();
    final controller = isLeft ? _leftVerticalScroll : _rightVerticalScroll;

    final body = ListView.builder(
      controller: controller,
      itemCount: widget.data.rows.length,
      itemBuilder: (_, rowIndex) {
        final row = widget.data.rows[rowIndex];
        return Row(
          children: List.generate(columns.length, (ci) {
            final colIndex = isLeft ? ci : fixed + ci;
            final cell = row[colIndex];
            return _buildCell(
              width: widths[ci],
              height: widget.rowHeight,
              child: _cellFromData(rowIndex, colIndex),
              bg: cell.backgroundColor,
              border: cell.border,
            );
          }),
        );
      },
    );

    if (isLeft) {
      final totalWidth = widths.fold(0.0, (a, b) => a + b);
      return SizedBox(width: totalWidth, child: body);
    }

    final totalWidth = widths.fold(0.0, (a, b) => a + b);
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _rightHorizontalScroll,
        child: SizedBox(width: totalWidth, child: body),
      ),
    );
  }

  // ---------- BUILD ----------
  @override
  Widget build(BuildContext context) {
    final totalCols = _leafColumns.length;
    final fixed = widget.fixedColumns.clamp(0, totalCols);
    // final heights =
    //     (widget.data.rows.length * widget.rowHeight) +
    //     widget.headerHeight +
    //     widget.subHeaderHeight;    //analyze this part later to calculate dynamic height of the table
    final leftHeader = fixed > 0
        ? _buildHeaderArea(fixed: fixed, isLeft: true)
        : const SizedBox.shrink();
    final rightHeader = _buildHeaderArea(fixed: fixed, isLeft: false);

    final leftBody = fixed > 0
        ? _buildBodyPart(fixed: fixed, isLeft: true)
        : const SizedBox.shrink();
    final rightBody = _buildBodyPart(fixed: fixed, isLeft: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fixed > 0) leftHeader,
              Expanded(child: rightHeader),
            ],
          ),
          SizedBox(
            height:widget.tableHeight ?? 400,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [if (fixed > 0) leftBody, rightBody],
            ),
          ),
        ],
      ),
    );
  }
}
