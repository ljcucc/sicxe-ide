import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_object_program_tab/object_code_visualize_provider.dart';
import 'package:sicxe/utils/sicxe/assembler/object_code.dart';
import 'package:sicxe/utils/sicxe/assembler/object_program_record.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';
import 'package:sicxe/utils/sicxe/emulator/target_address.dart';

typedef AssembleFunction = String Function(int operand);

// Map<OpCodes, AssembleFunction>

/// The directive type of a line or statement.
enum LlbAssemblerDirectiveType {
  START,
  END,
  RESB,
  RESW,
  WORD,
  BYTE,
  BASE,
  NOBASE,
  IS_NOT_DIRECTIVE,
}

/// The job of LlbAssembler is just to glue everything together.
///
/// LlbAssembler is a assembler designed by Leland L. Beck
/// in Book "System Software - An Introduction to Systme Programming"
/// which written in the style of OOP
class LlbAssembler {
  final String text;
  Map<String, int> symtab = {};
  List<ObjectProgramRecord> records = [];

  int startingLoc = 0;
  int locctr = 0;
  int baseLoc = 0;

  LlbAssembler({required this.text});

  pass1() {
    symtab = {};
    locctr = 0;
    startingLoc = 0;

    List<String> lines = text.split("\n");
    for (final (index, line) in lines.indexed) {
      if (line.isEmpty || line[0] == ".") continue;

      final parsed = LlbAssemblerLineParser(
        line: line,
        locctr: locctr,
        baseLoc: baseLoc,
      );

      // starting line detection
      if (index == 0 &&
          parsed.directiveType == LlbAssemblerDirectiveType.START) {
        locctr = parsed.operand.toInt();
        print("derective: START, $locctr");
        startingLoc = locctr;
      }

      // symbol detection
      if (parsed.hasLabel) {
        if (symtab.containsKey(parsed.label)) {
          throw "duplicate symbol: ${parsed.label}";
        }

        symtab[parsed.label] = locctr;
        print("added ${parsed.label} to symtab, with loc $locctr");
      }

      print("parsed $line in $locctr, len: ${parsed.objLength}");
      // constants & reserved detection
      locctr += parsed.objLength;
    }
  }

  pass2() {
    records = [];
    baseLoc = 0;

    // store the program length and reset locctr for object program generate
    final programLenth = locctr - startingLoc;
    locctr = startingLoc;

    final ObjectCodeGenerate codeGenerate = ObjectCodeGenerate(
      symtab: symtab,
      programLenth: programLenth,
    );

    List<String> lines = text.split("\n");
    for (final (index, line) in lines.indexed) {
      if (line.isEmpty || line[0] == ".") continue;

      final parsed = LlbAssemblerLineParser(
        line: line,
        locctr: locctr,
        baseLoc: baseLoc,
      );

      if (parsed.directiveType == LlbAssemblerDirectiveType.BASE) {
        baseLoc = symtab[parsed.operand.toSymbol()] ?? 0;
      }

      codeGenerate.push(parsed);

      // constants & reserved detection
      locctr += parsed.objLength;
    }

    codeGenerate.ending(startingLoc);
    records = codeGenerate.records;
  }
}
