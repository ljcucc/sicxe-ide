import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/overview_card.dart';

import 'package:google_fonts/google_fonts.dart';

class MemoryInspector extends StatelessWidget {
  const MemoryInspector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
      final mem = emulator.getMemory();

      return OverviewCard(
        expanded: true,
        title: Text("Memory overview"),
        // onInfoOpen: () =>
        //     Provider.of<DocumentDisplayProvider>(context, listen: false)
        //         .changeMarkdown("memory.md"),
        child: Card(
          elevation: 0,
          shadowColor: Colors.transparent,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            addAutomaticKeepAlives: false,
            itemCount: 0xFFF ~/ 8 + 1,
            itemBuilder: (context, index) {
              return Text(
                "${(index * 8).toRadixString(16).padLeft(5, "0").toUpperCase()}  ${mem.getRange(index * 8, index * 8 + 8).map((e) => e.toRadixString(16).padLeft(2, '0')).join(" ")}",
                style: GoogleFonts.spaceMono(),
              );
            },
          ),
        ),
      );
    });
  }
}
