import 'package:flutter/material.dart';
import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/assembler/object_program_record.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';

class ObjectCodeGenerateOperand {
  final LlbAssemblerLineParser parsed;
  final Map<String, int> symtab;

  int operandValue = 0;
  bool isPcAddressing = false;

  ObjectCodeGenerateOperand(this.parsed, this.symtab) {
    _parseByAddressing();
  }

  _parseByAddressing() {
    if (!parsed.hasOperand) return;
    if (instrFormat1.contains(parsed.opcode) ||
        instrFormat2.contains(parsed.opcode)) return;
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

class ObjectCodeGenerateOpcode {
  final LlbAssemblerLineParser parsed;
  final ObjectCodeGenerateOperand operand;

  ObjectCodeGenerateOpcode(
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

class ObjectCodeGenerate {
  List<ObjectProgramRecord> records = [];
  final Map<String, int> symtab;
  final int programLenth;

  ObjectCodeGenerate({
    required this.symtab,
    required this.programLenth,
  });

  push(LlbAssemblerLineParser parsed) {
    if (parsed.opcode != OpCodes.OP_NOT_FOUND) {
      _instructionTextRecord(parsed);
      print(parsed.opcode);
    }
    if (parsed.directiveType == LlbAssemblerDirectiveType.START) {
      _headerRecord();
      return;
    }
    if (parsed.directiveType == LlbAssemblerDirectiveType.BYTE) {
      _byteTextRecord(parsed);
    }
    if (parsed.directiveType == LlbAssemblerDirectiveType.WORD) {
      final operandValue =
          int.tryParse(parsed.operand.colOperand) ?? 0 & 0xFFFFFF;
      final objectCode = operandValue.toRadixString(16).padLeft(6, '0');
      _appendToRecord(parsed.locctr, objectCode, parsed);
    }
    if (parsed.directiveType == LlbAssemblerDirectiveType.RESW ||
        parsed.directiveType == LlbAssemblerDirectiveType.RESB) {
      TextRecord tr = records.last as TextRecord;
      if (tr.length != 0) {
        tr = TextRecord();
        records.add(tr);
        print("split new textRecord");
      }
      print("update last startingAddress");
      tr.startingAddress = parsed.locctr.toRadixString(16).padLeft(6, '0');
    }
  }

  // TODO: write a class for this textRecord.
  _byteTextRecord(LlbAssemblerLineParser parsed) {
    final colOperand = parsed.operand.colOperand;
    String objectCode = "";
    if (colOperand.startsWith("X")) {
      final innerString = colOperand.split("'")[1] ?? "";
      final operandValue = int.tryParse(innerString, radix: 16) ?? 0;
      objectCode = _toFixedHexString(value: operandValue, pad: 2);
    } else if (colOperand.startsWith("C")) {
      objectCode = colOperand
          .split("'")[1]
          .characters
          .map((e) => e.codeUnitAt(0).toRadixString(16).padLeft(2, '0'))
          .join();
    }

    _appendToRecord(parsed.locctr, objectCode, parsed);
  }

  String _toFixedHexString({required int value, int pad = 2}) {
    return value.toRadixString(16).padLeft(pad, '0');
  }

  /// Generate instruction object code
  _instructionTextRecord(LlbAssemblerLineParser parsed) {
    final ocgOperand = ObjectCodeGenerateOperand(parsed, symtab);
    final ocgOpcode = ObjectCodeGenerateOpcode(parsed, ocgOperand);
    final objectCode = ocgOpcode.toInstructionHexString();

    print("isPCAddressing: ${ocgOperand.isPcAddressing}");

    _appendToRecord(parsed.locctr, objectCode, parsed);
  }

  _appendToRecord(
    int locctr,
    String objectCode,
    LlbAssemblerLineParser parsed,
  ) {
    TextRecord tr = records.last as TextRecord;
    if (tr.length == 0) {
      tr.startingAddress = locctr.toRadixString(16).padLeft(6, '0');
    }
    if (!tr.add(ObjectCodeBlock(
      string: objectCode,
      src: parsed.line,
    ))) {
      tr = TextRecord();
      tr.startingAddress = locctr.toRadixString(16).padLeft(6, '0');
      tr.add(ObjectCodeBlock(
        string: objectCode,
        src: parsed.line,
      ));
      records.add(tr);
    }
  }

  _opcodeImmediateOperand(LlbAssemblerLineParser parsed) {}

  _headerRecord() {
    final header = HeaderRecord();
    header.programName = symtab.entries.first.key.padRight(6);

    header.length = _toFixedHexString(
      value: programLenth,
      pad: 6,
    ).toUpperCase();

    header.startingAddress = _toFixedHexString(
      value: symtab.entries.first.value,
      pad: 6,
    ).toUpperCase();

    records.add(header);
    records.add(TextRecord());
  }

  ending(int startingLoc) {
    if ((records.last as TextRecord).length == 0) {
      records.removeLast();
    }

    final er = EndRecord();
    er.bootAddress = startingLoc.toRadixString(16).padLeft(6, '0');
    records.add(er);
  }
}
