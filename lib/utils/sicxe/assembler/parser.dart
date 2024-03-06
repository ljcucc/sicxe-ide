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

class LlbAssemblerLineParserOperand {
  final String colOperand;

  LlbAssemblerLineParserOperand({required this.colOperand});

  int toInt() {
    return int.tryParse(colOperand, radix: 16) ?? 0;
  }

  String toSymbol() {
    return _getSymbolFromOperand(colOperand);
  }

  int? toNumberSymbol() {
    return int.tryParse(toSymbol());
  }

  _getSymbolFromOperand(String colOperand) =>
      colOperand.replaceAll("#", "").replaceAll(",X", "").replaceAll("@", "");

  List<String> getSplitRegisterSymbol() {
    return colOperand.split(",").map((e) => e.trim()).toList();
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

/// The job of LlbAssemblerLineParser is to parse and collect, be able to provide as much details as possible from a line.
class LlbAssemblerLineParser {
  final int locctr;
  final String line;

  int baseLoc;

  String _colLabel = "";
  String _colOperand = "";
  String _colOpcode = "";

  OpCodes opcode = OpCodes.OP_NOT_FOUND;

  LlbAssemblerLineParser({
    required this.line,
    required this.locctr,
    required this.baseLoc,
  }) {
    final splitedLine = _split2cols(line);

    if (hasLabel) {
      // Shift the first item as label
      _colLabel = splitedLine.removeAt(0).toUpperCase();
    }

    _colOpcode = splitedLine[0].toUpperCase();
    _colOperand = splitedLine.length > 1 ? splitedLine[1] : "";

    opcode = getOpcodeByString(getMnemonicFromOpcode(_colOpcode));
  } // this function will split a line of string into cols without breaking string paren.

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

  bool get hasLabel => line[0] != " ";
  get label => _colLabel;

  bool get hasOperand => _colOperand != "";

  LlbAssemblerLineParserOperand get operand =>
      LlbAssemblerLineParserOperand(colOperand: _colOperand);

  bool get flagX => _colOperand.endsWith(",X");
  bool get flagE => _colOpcode.startsWith("+");
  bool get flagN => _colOperand.startsWith("@");
  bool get flagI => _colOperand.startsWith("#");

  LlbAssemblerDirectiveType get directiveType {
    return switch (_colOpcode) {
      "START" => LlbAssemblerDirectiveType.START,
      "RESW" => LlbAssemblerDirectiveType.RESW,
      "RESB" => LlbAssemblerDirectiveType.RESB,
      "WORD" => LlbAssemblerDirectiveType.WORD,
      "BYTE" => LlbAssemblerDirectiveType.BYTE,
      "BASE" => LlbAssemblerDirectiveType.BASE,
      "NOBASE" => LlbAssemblerDirectiveType.NOBASE,
      String() => LlbAssemblerDirectiveType.IS_NOT_DIRECTIVE,
    };
  }

  getMnemonicFromOpcode(String colOpcode) => colOpcode.replaceAll("+", "");

  int getInstrLen() {
    if (instrFormat1.contains(opcode)) {
      return 1;
    } else if (instrFormat2.contains(opcode)) {
      return 2;
    } else if (flagE) {
      return 4;
    }
    return 3;
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

  int get objLength {
    if (opcode != OpCodes.OP_NOT_FOUND) return getInstrLen();

    if (directiveType == LlbAssemblerDirectiveType.WORD) return 3;
    if (directiveType == LlbAssemblerDirectiveType.BYTE) {
      final segments = _colOperand.split('\'');
      if (segments[0] == 'C') return segments[1].length;
      // if (segments[0] == 'X')
      return 1;
    }
    if (directiveType == LlbAssemblerDirectiveType.RESW) {
      return 3 * (int.tryParse(_colOperand, radix: 10) ?? 0);
    }
    if (directiveType == LlbAssemblerDirectiveType.RESB) {
      return int.tryParse(_colOperand, radix: 10) ?? 0;
    }

    print("statement not found, $opcode");

    return 0;
  }
}
