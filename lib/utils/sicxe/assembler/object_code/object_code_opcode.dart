import 'package:sicxe/utils/sicxe/assembler/object_code/object_code_operand.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';

/// Responsible for generate final object code
class ObjectCodeOpcode {
  final LlbAssemblerLineParser parsed;
  final ObjectCodeOperand operand;

  ObjectCodeOpcode(
    this.parsed,
    this.operand,
  );

  int _opcodeToHex(OpCodes opcode) {
    final opcodeHex = DecodeTable.keys
        .firstWhere((hexValue) => DecodeTable[hexValue] == opcode);
    return opcodeHex;
  }

  String toInstructionHexString() {
    // is format 3 and foramt 4
    if (instrFormat1.contains(parsed.opcode)) {
      return _opcodeToHex(parsed.opcode).toRadixString(16).padLeft(2, '0');
    }
    if (instrFormat2.contains(parsed.opcode)) {
      final opcodeString =
          _opcodeToHex(parsed.opcode).toRadixString(16).padLeft(2, '0');
      final r1 = (parsed.operand.r1Index & 0xF).toRadixString(16);
      final r2 = (parsed.operand.r2Index & 0xF).toRadixString(16);
      return "$opcodeString$r1$r2";
    }
    return _F3n4toHexString();
  }

  // turn the format3 and foramt 4 into hex string
  String _F3n4toHexString() {
    int opcode = _opcodeToHex(parsed.opcode);
    int xbpe = 0;
    if (parsed.flagN) {
      opcode |= 0x02;
    }
    if (parsed.flagI) {
      opcode |= 0x01;
    }

    if (!parsed.flagN && !parsed.flagI) {
      opcode |= 0x03;
    }

    if (parsed.flagX) {
      xbpe |= 0x80;
    }

    if (!parsed.flagE &&
        parsed.operand.toNumberSymbol() == null &&
        OpCodes.RSUB != parsed.opcode) {
      if (operand.isPcAddressing) {
        xbpe |= 0x20;
      } else {
        xbpe |= 0x40;
      }
    }

    if (parsed.flagE) {
      xbpe |= 0x10;
    }

    if (parsed.flagE) {
      int value =
          opcode << 24 | xbpe << 16 | operand.operandValue.toUnsigned(20);
      return value.toRadixString(16).padLeft(8, '0');
    } else {
      int value =
          opcode << 16 | xbpe << 8 | operand.operandValue.toUnsigned(12);
      return value.toRadixString(16).padLeft(6, '0');
    }
  }
}
