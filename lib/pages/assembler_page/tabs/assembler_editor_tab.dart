import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/assembler_page_provider.dart';
import 'package:sicxe/utils/assembler.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/overview_card.dart';

class AssemblerEditorTab extends StatelessWidget {
  const AssemblerEditorTab({
    super.key,
  });

  _onCompile(AssemblerPageProvider assemblerPageProvider, context) {
    assemblerPageProvider.onCompile();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Code is compiled, view the object code in its tab."),
        action: SnackBarAction(
          label: "View",
          onPressed: () => DefaultTabController.of(context).animateTo(1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssemblerPageProvider>(
        builder: (context, assemblerPageProvider, _) {
      return SafeArea(
        minimum: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 700)
                  return Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () =>
                            _onCompile(assemblerPageProvider, context),
                        label: Text("Compile"),
                        icon: Icon(Icons.play_arrow_outlined),
                      ),
                      SizedBox(width: 16),
                      FilledButton.tonalIcon(
                        onPressed: () =>
                            _onCompile(assemblerPageProvider, context),
                        label: Text("Upload"),
                        icon: Icon(Icons.file_upload_outlined),
                      ),
                    ],
                  );
                else
                  return Row(
                    children: [
                      IconButton.filled(
                        onPressed: () =>
                            _onCompile(assemblerPageProvider, context),
                        icon: Icon(Icons.play_arrow_outlined),
                      ),
                      SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: () =>
                            _onCompile(assemblerPageProvider, context),
                        icon: Icon(Icons.file_upload_outlined),
                      ),
                    ],
                  );
              }),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: CodeField(
                    background: Colors.transparent,
                    cursorColor: Theme.of(context).colorScheme.onSurface,
                    controller: assemblerPageProvider.codeController!,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
