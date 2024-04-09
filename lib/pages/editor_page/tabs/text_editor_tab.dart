import 'package:code_text_field/code_text_field.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class TextEditorTab extends StatefulWidget {
  final String filename;
  final String text;
  final Function(String) onChange;

  const TextEditorTab({
    super.key,
    required this.filename,
    required this.text,
    required this.onChange,
  });

  @override
  State<TextEditorTab> createState() => _TextEditorTabState();
}

class _TextEditorTabState extends State<TextEditorTab> {
  CodeController? codeController;

  @override
  void initState() {
    super.initState();

    // _loadString();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  // _loadString() async {
  //   final editor = Provider.of<EditorWorkflow>(context, listen: false);

  //   editor.contents.getFileString(widget.filename, fallbackString: "");

  //   // if (codeController?.text !=
  //   //     editor.contents.getFileString(widget.filename)) {
  //   //   codeController?.text =
  //   //       ;
  //   // }
  // }

  _setupCodeController() async {
    final colorScheme = Theme.of(context).colorScheme;
    // Instantiate the CodeController
    final primary = colorScheme.primary;
    final secondary = colorScheme.secondary;
    final tertiary = colorScheme.tertiary;
    codeController = CodeController(
      text: widget.text,
      stringMap: {
        'WORD': TextStyle(color: primary),
        'BYTE': TextStyle(color: primary),
        'RESW': TextStyle(color: primary),
        'RESB': TextStyle(color: primary),
        'START': TextStyle(color: primary),
        'END': TextStyle(color: primary),
        'BASE': TextStyle(color: primary),
      },
      patternMap: {
        r"\..*": TextStyle(color: tertiary.withOpacity(.5)),
        r"C'[^']+'": TextStyle(color: secondary.harmonizeWith(Colors.green)),
        r"X'[^']+'": TextStyle(color: secondary.harmonizeWith(Colors.red)),
        r"[^,X\s]+,X": TextStyle(color: secondary.harmonizeWith(Colors.blue)),
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    codeController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (codeController == null) {
      _setupCodeController();
    }

    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      // if (codeController?.text !=
      //     editor.contents.getFileString(widget.filename)) {
      //   codeController?.text =
      //       editor.contents.getFileString(widget.filename, fallbackString: "");
      // }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: CodeField(
                onChanged: widget.onChange,
                background: Colors.transparent,
                cursorColor: Theme.of(context).colorScheme.onSurface,
                controller: codeController!,
                textStyle: GoogleFonts.robotoMono(
                    color: Theme.of(context).colorScheme.onSurface),
                lineNumberStyle: LineNumberStyle(
                  width: 50,
                ),
                lineNumberBuilder: (p0, p1) {
                  return TextSpan(
                    text: (p0).toRadixString(16).toUpperCase(),
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
        ],
      );
    });
  }
}
