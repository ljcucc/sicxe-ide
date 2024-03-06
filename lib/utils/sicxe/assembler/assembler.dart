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

  /// The starting location
  int startingLoc = 0;

  int programLenth = 0;

  LlbAssembler({required this.text});

  LlbAssemblerLineParser parseLine(int index, String line, int locctr) {
    final parsed = LlbAssemblerLineParser(
      line: line,
      locctr: locctr,
      baseLoc: 0,
    );

    return parsed;
  }

  /// reset all data structure into initial state.
  init() {
    parsedLines = [];
    records = [];
    symtab = {};
    startingLoc = 0;
    programLenth = 0;
  }

  /// all parsed object will store here
  List<LlbAssemblerLineParser> parsedLines = [];

  /// pass1 will parse each line, and store it for forward referenced.
  pass1() {
    init();

    // current location
    int locctr = 0;

    List<String> lines = text.split("\n");

    for (final (index, line) in lines.indexed) {
      if (line.isEmpty || line[0] == ".") continue;

      final parsed = parseLine(index, line, locctr);

      if (index == 0 &&
          parsed.directiveType == LlbAssemblerDirectiveType.START) {
        locctr = parsed.operand.toInt();
        startingLoc = locctr;
      }

      // symbol detection
      if (parsed.hasLabel) {
        if (symtab.containsKey(parsed.label)) {
          throw "duplicate symbol: ${parsed.label}";
        }

        symtab[parsed.label] = locctr;
      }

      locctr += parsed.objLength;
      parsedLines.add(parsed);
    }

    // store the program length and reset locctr for object program generate
    programLenth = locctr - startingLoc;
  }

  // TODO: combine two pass into one by recycling parsed lines
  pass2() {
    int baseLoc = 0;

    final ObjectCodeGenerate codeGenerate = ObjectCodeGenerate(
      symtab: symtab,
      programLenth: programLenth,
    );

    for (var parsed in parsedLines) {
      if (parsed.directiveType == LlbAssemblerDirectiveType.BASE) {
        baseLoc = symtab[parsed.operand.toSymbol()] ?? 0;
      }

      parsed.baseLoc = baseLoc;
      codeGenerate.push(parsed);
    }

    codeGenerate.ending(startingLoc);
    records = codeGenerate.records;
  }
}
