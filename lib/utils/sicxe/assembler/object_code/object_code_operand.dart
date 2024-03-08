import 'package:sicxe/utils/sicxe/assembler/object_code/object_code_builder.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';

/// Calculate values of operand, which will convert symbol string into locatoin by symtab,
/// and calculate final value with PC or base
class ObjectCodeBuilderOperand extends ObjectCodeBuilder {
  int operandValue = 0;
  bool isPcAddressing = false;

  ObjectCodeBuilderOperand({required super.parserContext});

  _parseByAddressing(ObjectCodeBuilderContext context) {
    if (parserContext.colOperand.isEmpty) return;

    final opcode = LineParserOpcode(context: parserContext).opcode;
    final operand = LineParserOperand(context: parserContext);

    // is format1 or format2
    if (instrFormat1.contains(opcode) || instrFormat2.contains(opcode)) return;

    // is no operand command
    if (OpCodes.RSUB == opcode) return;

    // if symbal is a constant with in 0-4095
    if (operand.toNumberSymbol() != null) {
      operandValue = operand.toNumberSymbol() ?? 0;
      return;
    }

    final stringSymbol = operand.toSymbol();

    if (!context.symtab.containsKey(stringSymbol)) {
      throw "undefined symbol: ${stringSymbol}";
    }

    int symbolLoc = context.symtab[stringSymbol] ?? 0;

    if (parserContext.flagE) {
      operandValue = symbolLoc;
      return;
    }

    isPcAddressing = _isPcAddressingValid(parserContext, symbolLoc);
    if (isPcAddressing) {
      final objLength = LineParserCodeLength(context: parserContext).objLength;
      final pcLoc = parserContext.locctr + objLength;
      operandValue = symbolLoc - pcLoc;
    } else {
      operandValue = symbolLoc - parserContext.baseLoc;
    }
  }

  String toHexString() {
    return operandValue
        .toUnsigned(parserContext.flagE ? 20 : 12)
        .toRadixString(16)
        .padLeft(parserContext.flagE ? 5 : 3);
  }

  // if it's be able to do pc addressing
  _isPcAddressingValid(LineParserContext context, symbolLoc) {
    final d = symbolLoc - context.locctr;
    print("d: ${symbolLoc - context.locctr}");
    print("flagE: ${context.flagE}");
    bool valid = false;

    if (context.flagE) {
      // is format 4
      valid = d < 524288 && d >= -524288;
    } else {
      // is format 3
      valid = d < 2048 && d >= -2048;
    }

    return valid;
  }

  @override
  build(ObjectCodeBuilderContext context) {
    _parseByAddressing(context);
  }
}
