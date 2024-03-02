import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/assembler_page_provider.dart';
import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/sicxe_editor_workflow.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/overview_card.dart';

class AssemblerSymtabWidget extends StatelessWidget {
  const AssemblerSymtabWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      final assembler = (editor as SicxeEditorWorkflow).assembler;

      return OverviewCard(
        expanded: true,
        title: Text("Symbols (SYMTAB)"),
        onInfoOpen: () =>
            Provider.of<DocumentDisplayProvider>(context, listen: false)
                .changeMarkdown("symtab.md"),
        child: Card(
          shadowColor: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text("Symbol")),
                  DataColumn(label: Text("Loc")),
                ],
                rows: [
                  for (MapEntry<String, int> symbol
                      in (assembler?.symtab ?? {}).entries)
                    DataRow(cells: [
                      DataCell(Text(symbol.key)),
                      DataCell(Text(
                        symbol.value.toRadixString(16).toUpperCase(),
                        style: GoogleFonts.spaceMono(),
                      )),
                    ])
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
