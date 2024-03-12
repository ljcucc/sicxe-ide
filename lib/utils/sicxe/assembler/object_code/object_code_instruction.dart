import 'package:sicxe/utils/sicxe/assembler/object_code/object_code_builder.dart';
import 'package:sicxe/utils/sicxe/assembler/object_code/object_code_operand.dart';
import 'package:sicxe/utils/sicxe/assembler/object_program_record.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';

/// Responsible for generate final object code
class ObjectCodeBuilderInstruction extends ObjectCodeBuilder {
  ObjectCodeBuilderInstruction({required super.parserContext});

  int _opcodeToHex(OpCodes opcode) {
    final opcodeHex = DecodeTable.keys
        .firstWhere((hexValue) => DecodeTable[hexValue] == opcode);
    return opcodeHex;
  }

  String toInstructionHexString(context) {
    final opcode = LineParserOpcode(context: parserContext).opcode;
    final operand = LineParserOperand(context: parserContext);

    // is format 3 and foramt 4
    if (instrFormat1.contains(opcode)) {
      return _opcodeToHex(opcode).toRadixString(16).padLeft(2, '0');
    }
    if (instrFormat2.contains(opcode)) {
      final opcodeString =
          _opcodeToHex(opcode).toRadixString(16).padLeft(2, '0');
      final r1 = (operand.r1Index & 0xF).toRadixString(16);
      final r2 = (operand.r2Index & 0xF).toRadixString(16);
      return "$opcodeString$r1$r2";
    }
    return _f3n4toHexString(context);
  }

  // turn the format3 and foramt 4 into hex string
  String _f3n4toHexString(context) {
    final parsedOpcode = LineParserOpcode(context: parserContext).opcode;
    final parsedOperand = LineParserOperand(context: parserContext);
    final operand = ObjectCodeBuilderOperand(parserContext: parserContext);
    final literal = LineParserLiterals(context: parserContext);

    operand.build(context);

    int opcode = _opcodeToHex(parsedOpcode);
    int xbpe = 0;
    if (parserContext.flagN) {
      opcode |= 0x02;
    }
    if (parserContext.flagI) {
      opcode |= 0x01;
    }

    if (!parserContext.flagN && !parserContext.flagI) {
      opcode |= 0x03;
    }

    if (parserContext.flagX) {
      xbpe |= 0x80;
    }

    if (!parserContext.flagE &&
        parsedOperand.toNumberSymbol() == null &&
        OpCodes.RSUB != parsedOpcode) {
      if (operand.isPcAddressing) {
        xbpe |= 0x20;
      } else {
        xbpe |= 0x40;
      }
    }

    if (parserContext.flagE) {
      xbpe |= 0x10;
    }

    if (parserContext.flagE) {
      int value =
          opcode << 24 | xbpe << 16 | operand.operandValue.toUnsigned(20);
      return value.toRadixString(16).padLeft(8, '0');
    } else {
      int value =
          opcode << 16 | xbpe << 8 | operand.operandValue.toUnsigned(12);
      return value.toRadixString(16).padLeft(6, '0');
    }
  }

  @override
  build(ObjectCodeBuilderContext context) {
    final objectCode = toInstructionHexString(context);

    context.pushTextRecordPart(objectCode, parserContext);

    // generate modification record (if need)
    if (parserContext.flagI || !parserContext.flagE) return;
    ObjectCodeBuilderModificationRecord(parserContext: parserContext)
        .build(context);
  }
}

class ObjectCodeBuilderModificationRecord extends ObjectCodeBuilder {
  ObjectCodeBuilderModificationRecord({required super.parserContext});

  @override
  build(ObjectCodeBuilderContext context) {
    if (parserContext.flagI || !parserContext.flagE) return;

    final modiRecord = ModificationRecord(
      startingLocation:
          toFixedHexString(value: parserContext.locctr + 1, pad: 6),
      digitLength: "05",
    );
    context.modiRecords.add(modiRecord);
  }
}
