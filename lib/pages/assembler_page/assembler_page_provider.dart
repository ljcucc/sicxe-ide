import 'package:code_text_field/code_text_field.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:sicxe/pages/assembler_page/assembler_examples.dart';

class AssemblerPageProvider extends ChangeNotifier {
  CodeController? codeController;

  final ColorScheme colorScheme;

  AssemblerPageProvider({
    required this.colorScheme,
  }) {
    _setupCodeController();
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
      'BASE': TextStyle(color: primary),
    }, patternMap: {
      r"\..*": TextStyle(color: tertiary.withOpacity(.5)),
      r"C'[^']+'": TextStyle(color: secondary.harmonizeWith(Colors.green)),
      r"X'[^']+'": TextStyle(color: secondary.harmonizeWith(Colors.red)),
      r"[^,X\s]+,X": TextStyle(color: secondary.harmonizeWith(Colors.blue)),
    });
  }
}
