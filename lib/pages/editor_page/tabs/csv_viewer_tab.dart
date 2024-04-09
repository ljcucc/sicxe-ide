import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class CsvViewerTab extends StatelessWidget {
  final String sourceString;

  const CsvViewerTab({
    super.key,
    required this.sourceString,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      final csv = CsvToListConverter().convert(sourceString);

      return SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: [
                for (int i = 0; i < csv.first.length; i++)
                  DataColumn(
                    label: Text(
                      csv.first[i],
                    ),
                  )
              ],
              rows: [
                for (final row in csv.sublist(1))
                  DataRow(
                    cells: [
                      for (final cell in row) DataCell(Text(cell.toString())),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
