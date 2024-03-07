import 'package:sicxe/utils/sicxe/assembler/parser.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';

/// Calculate values of operand, which will convert symbol string into locatoin by symtab,
/// and calculate final value with PC or base
class ObjectCodeOperand {
  final LlbAssemblerLineParser parsed;
  final Map<String, int> symtab;

  int operandValue = 0;
  bool isPcAddressing = false;

  ObjectCodeOperand(this.parsed, this.symtab) {
    _parseByAddressing();
  }

  _parseByAddressing() {
    if (parsed.colOperand.isEmpty) return;

    // is format1 or format2
    if (instrFormat1.contains(parsed.opcode) ||
        instrFormat2.contains(parsed.opcode)) return;

    // is no operand command
    if (OpCodes.RSUB == parsed.opcode) return;

    // if symbal is a constant with in 0-4095
    if (parsed.operand.toNumberSymbol() != null) {
      operandValue = parsed.operand.toNumberSymbol() ?? 0;
      return;
    }

    final stringSymbol = parsed.operand.toSymbol();

    if (!symtab.containsKey(stringSymbol)) {
      throw "undefined symbol: ${stringSymbol}";
    }

    int symbolLoc = symtab[stringSymbol] ?? 0;

    if (parsed.flagE) {
      operandValue = symbolLoc;
      return;
    }

    isPcAddressing = _isPcAddressingValid(symbolLoc);
    if (isPcAddressing) {
      final pcLoc = parsed.locctr + parsed.objLength;
      operandValue = symbolLoc - pcLoc;
    } else {
      operandValue = symbolLoc - parsed.baseLoc;
    }
  }

  String toHexString() {
    return operandValue
        .toUnsigned(parsed.flagE ? 20 : 12)
        .toRadixString(16)
        .padLeft(parsed.flagE ? 5 : 3);
  }

  // if it's be able to do pc addressing
  _isPcAddressingValid(int symbolLoc) {
    final d = symbolLoc - parsed.locctr;
    print("d: ${symbolLoc - parsed.locctr}");
    print("flagE: ${parsed.flagE}");
    bool valid = false;

    if (parsed.flagE) {
      // is format 4
      valid = d < 524288 && d >= -524288;
    } else {
      // is format 3
      valid = d < 2048 && d >= -2048;
    }

    return valid;
  }
}
