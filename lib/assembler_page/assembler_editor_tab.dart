import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sicxe/assembler_page/assembler.dart';
import 'package:sicxe/description_dialog.dart';
import 'package:sicxe/documents.dart';
import 'package:sicxe/overview_card.dart';

class AssemblerEditorTab extends StatelessWidget {
  final CodeController? codeController;
  final LlbAssembler? assembler;

  const AssemblerEditorTab({
    super.key,
    this.codeController,
    required this.assembler,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16).copyWith(bottom: 100),
            child: CodeField(
              cursorColor: Theme.of(context).colorScheme.onSurface,
              controller: codeController!,
              textStyle: GoogleFonts.robotoMono(
                  color: Theme.of(context).colorScheme.onSurface),
              lineNumberStyle: LineNumberStyle(
                width: 50,
              ),
              lineNumberBuilder: (p0, p1) {
                return TextSpan(
                  text: (p0 * 5).toString(),
                  style: GoogleFonts.robotoMono(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(.5),
                  ),
                );
              },
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        SafeArea(
          minimum: EdgeInsets.all(8),
          child: SizedBox(
            width: 300,
            child: OverviewCard(
              expanded: true,
              title: Text("SYMTAB"),
              description: FutureBuilder(
                future: getDocument("object_program.md"),
                builder: (context, snapshot) {
                  return DescriptionDialog(
                    title: "SYMTAB",
                    markdown: snapshot.data ?? "",
                  );
                },
              ),
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
            ),
          ),
        ),
      ],
    );
  }
}
