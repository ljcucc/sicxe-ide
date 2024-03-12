import 'dart:math';

import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';

const registerIndexMap = [
  "A",
  "X",
  "L",
  "B",
  "S",
  "T",
  "F",
  "",
  "PC",
  "SW",
];

abstract class LinePaerserBuilder {
  final LineParserContext context;
  LinePaerserBuilder({required this.context});
}

/// A starting point for parse stage, parse the columns
class LineParser extends LinePaerserBuilder {
  LineParser({required super.context}) {
    final splitedLine = _split2cols(context.line);

    final hasLabel = context.line[0] != " ";
    if (hasLabel) {
      // Shift the first item as label
      context.colLabel = splitedLine.removeAt(0).toUpperCase();
    }

    context.colOpcode = splitedLine[0].toUpperCase();
    context.colOperand = splitedLine.length > 1 ? splitedLine[1] : "";
  }

  List<String> _split2cols(String line) {
    const superSpaceReplacement = "SUPER_SPACE_REPLACEMENT";
    final processedString = line.split("'").indexed.map((e) {
      final (index, item) = e;
      if (index % 2 == 1) {
        return item.replaceAll(" ", superSpaceReplacement);
      }
      return item;
    }).join("'");

    return processedString
        .split(" ")
        .where((element) => element.isNotEmpty)
        .map((e) => e.replaceAll(superSpaceReplacement, " "))
        .toList();
  }
}

/// Provide information about opcode by parsing from source
class LineParserOpcode extends LinePaerserBuilder {
  LineParserOpcode({required super.context});

  OpCodes get opcode {
    return getOpcodeByString(context.colOpcode);
  }

  getOpcodeByString(String opcode) {
    String pureColOpcode =
        opcode.replaceAll("+", "").replaceAll("#", "").trim();
    final opcodeIndexMap = OpCodes.values.map((e) => e.name).toList();
    if (opcodeIndexMap.contains(pureColOpcode)) {
      return OpCodes.values[opcodeIndexMap.indexOf(pureColOpcode)];
    }
    return OpCodes.OP_NOT_FOUND;
  }

  /// return the length of instruction
  int get instructionLen {
    if (instrFormat1.contains(opcode)) {
      return 1;
    } else if (instrFormat2.contains(opcode)) {
      return 2;
    } else if (context.flagE) {
      return 4;
    }
    return 3;
  }
}

/// Get all information about operand by parsing
class LineParserOperand extends LinePaerserBuilder {
  LineParserOperand({required super.context});

  int toInt() {
    return int.tryParse(context.colOperand, radix: 16) ?? 0;
  }

  String toSymbol() {
    return _getSymbolFromOperand(context.colOperand);
  }

  int? toNumberSymbol() {
    return int.tryParse(toSymbol());
  }

  _getSymbolFromOperand(String colOperand) =>
      colOperand.replaceAll("#", "").replaceAll(",X", "").replaceAll("@", "");

  List<String> getSplitRegisterSymbol() {
    return context.colOperand.split(",").map((e) => e.trim()).toList();
  }

  /// get format 2 r1 index.
  int get r1Index {
    return max(registerIndexMap.indexOf(getSplitRegisterSymbol()[0]), 0);
  }

  /// get format 2 r2 index.
  int get r2Index {
    if (getSplitRegisterSymbol().length < 2) return 0;
    return max(registerIndexMap.indexOf(getSplitRegisterSymbol()[1]), 0);
  }
}

class LineParserLiterals extends LinePaerserBuilder {
  LineParserLiterals({required super.context});

  bool get isLiteral =>
      context.colOperand.isNotEmpty && context.colOperand[0] == '=';
  bool get isLocLiteralDefine =>
      context.colOperand.isNotEmpty && context.colOperand[0] == '*';
  bool get isLocLiteral =>
      context.colOperand.isNotEmpty && context.colOperand.startsWith("=*");
}

/// Get the object code legnth
class LineParserCodeLength extends LinePaerserBuilder {
  LineParserCodeLength({required super.context});

  /// return the length of object code, used for calculate locctr.
  int get objLength {
    final opcode = LineParserOpcode(context: context);
    if (opcode.opcode != OpCodes.OP_NOT_FOUND) return opcode.instructionLen;

    if (context.directiveType == LlbAssemblerDirectiveType.WORD) return 3;
    if (context.directiveType == LlbAssemblerDirectiveType.BYTE) {
      final segments = context.colOperand.split('\'');
      if (segments[0] == 'C') return segments[1].length;
      // if (segments[0] == 'X')
      return 1;
    }
    if (context.directiveType == LlbAssemblerDirectiveType.RESW) {
      return 3 * (int.tryParse(context.colOperand, radix: 10) ?? 0);
    }
    if (context.directiveType == LlbAssemblerDirectiveType.RESB) {
      return int.tryParse(context.colOperand, radix: 10) ?? 0;
    }

    print("statement not found, ${opcode.opcode}, ${context.line} ");

    return 0;
  }
}

/// Context of LineParser, provide none-other than value.
class LineParserContext {
  /// source line string
  final String line;

  /// location of the object code & base
  int locctr;
  int baseLoc = 0;

  /// Parsed raw label, operand, opcode column
  String colLabel = "";
  String colOperand = "";
  String colOpcode = "";

  LineParserContext({
    required this.line,
    required this.locctr,
  });

  bool get flagX => colOperand.endsWith(",X");
  bool get flagE => colOpcode.startsWith("+");
  bool get flagN => colOperand.startsWith("@");
  bool get flagI => colOperand.startsWith("#") || colOperand.startsWith("=*");

  LlbAssemblerDirectiveType get directiveType {
    return switch (colOpcode) {
      "START" => LlbAssemblerDirectiveType.START,
      "RESW" => LlbAssemblerDirectiveType.RESW,
      "RESB" => LlbAssemblerDirectiveType.RESB,
      "WORD" => LlbAssemblerDirectiveType.WORD,
      "BYTE" => LlbAssemblerDirectiveType.BYTE,
      "BASE" => LlbAssemblerDirectiveType.BASE,
      "NOBASE" => LlbAssemblerDirectiveType.NOBASE,
      "CSECT" => LlbAssemblerDirectiveType.CSECT,
      "LTORG" => LlbAssemblerDirectiveType.LTORG,
      String() => LlbAssemblerDirectiveType.IS_NOT_DIRECTIVE,
    };
  }
}
