import 'package:code_text_field/code_text_field.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sicxe/pages/assembler_page/assembler_examples.dart';
import 'package:sicxe/utils/assembler.dart';

class AssemblerPageProvider extends ChangeNotifier {
  LlbAssembler? assembler;
  CodeController? codeController;

  final ColorScheme colorScheme;

  AssemblerPageProvider({
    required this.colorScheme,
  }) {
    _setupCodeController();
  }

  onCompile() {
    assembler = LlbAssembler(text: codeController?.text ?? "");
    assembler?.pass1();
    assembler?.pass2();

    notifyListeners();
  }

  _setupCodeController() {
    // Instantiate the CodeController
    final primary = colorScheme.primary;
    final secondary = colorScheme.secondary;
    final tertiary = colorScheme.tertiary;
    codeController = CodeController(text: assemblerExampleCode, stringMap: {
      'WORD': TextStyle(color: primary),
      'BYTE': TextStyle(color: primary),
      'RESW': TextStyle(color: primary),
      'RESB': TextStyle(color: primary),
      'START': TextStyle(color: primary),
      'END': TextStyle(color: primary),
    }, patternMap: {
      r"\..*": TextStyle(color: tertiary.withOpacity(.5)),
      r"C'[^']+'": TextStyle(color: Colors.green.harmonizeWith(secondary)),
      r"X'[^']+'": TextStyle(color: Colors.red.harmonizeWith(secondary)),
      r"[^,X\s]+,X": TextStyle(color: Colors.blue.harmonizeWith(secondary)),
    });
  }
}
