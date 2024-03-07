import 'package:flutter/material.dart';
import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/assembler/object_program_record.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';
import 'package:sicxe/utils/sicxe/assembler/object_code/object_code_opcode.dart';
import 'package:sicxe/utils/sicxe/assembler/object_code/object_code_operand.dart';

String toFixedHexString({required int value, int pad = 2}) {
  return value.toRadixString(16).padLeft(pad, '0');
}

abstract class ObjectCodeBuilder {
  LlbAssemblerLineParser parsed;

  ObjectCodeBuilder({required this.parsed});

  build(ObjectCodeBuilderContext context);

  static resolve(LlbAssemblerLineParser parsed) {
    if (parsed.opcode != OpCodes.OP_NOT_FOUND) {
      return ObjectCodeBuilderOpcode(parsed: parsed);
    }
    if (parsed.directiveType == LlbAssemblerDirectiveType.START) {
      return ObjectCodeBuilderDirectiveStart(parsed: parsed);
    }
    if (parsed.directiveType == LlbAssemblerDirectiveType.BYTE) {
      return ObjectCodeBuilderDirectiveByte(parsed: parsed);
    }
    if (parsed.directiveType == LlbAssemblerDirectiveType.WORD) {
      return ObjectCodeBuilderDirectiveWord(parsed: parsed);
    }
    if (parsed.directiveType == LlbAssemblerDirectiveType.RESW ||
        parsed.directiveType == LlbAssemblerDirectiveType.RESB) {
      return ObjectCodeBuilderDirectiveRes(parsed: parsed);
    }
  }
}

class ObjectCodeBuilderOpcode extends ObjectCodeBuilder {
  ObjectCodeBuilderOpcode({required super.parsed});

  @override
  build(ObjectCodeBuilderContext context) {
    final operand = ObjectCodeOperand(parsed, context.symtab);
    final opcode = ObjectCodeOpcode(parsed, operand);
    final objectCode = opcode.toInstructionHexString();
    context.pushTextRecordPart(objectCode, operand.parsed);
  }
}

class ObjectCodeBuilderDirectiveStart extends ObjectCodeBuilder {
  ObjectCodeBuilderDirectiveStart({required super.parsed});

  @override
  build(ObjectCodeBuilderContext context) {
    final symtab = context.symtab;
    final header = HeaderRecord();
    header.programName = symtab.entries.first.key.padRight(6);

    header.length = toFixedHexString(
      value: context.programLenth,
      pad: 6,
    ).toUpperCase();

    header.startingAddress = toFixedHexString(
      value: symtab.entries.first.value,
      pad: 6,
    ).toUpperCase();

    context.records.add(header);
    context.records.add(TextRecord());
  }
}

class ObjectCodeBuilderDirectiveByte extends ObjectCodeBuilder {
  ObjectCodeBuilderDirectiveByte({required super.parsed});

  @override
  build(ObjectCodeBuilderContext context) {
    final colOperand = parsed.colOperand;
    String objectCode = "";
    if (colOperand.startsWith("X")) {
      final innerString = colOperand.split("'")[1] ?? "";
      final operandValue = int.tryParse(innerString, radix: 16) ?? 0;
      objectCode = toFixedHexString(value: operandValue, pad: 2);
    } else if (colOperand.startsWith("C")) {
      objectCode = colOperand
          .split("'")[1]
          .characters
          .map((e) => e.codeUnitAt(0).toRadixString(16).padLeft(2, '0'))
          .join();
    }

    context.pushTextRecordPart(objectCode, parsed);
  }
}

class ObjectCodeBuilderDirectiveWord extends ObjectCodeBuilder {
  ObjectCodeBuilderDirectiveWord({required super.parsed});

  @override
  build(ObjectCodeBuilderContext context) {
    final operandValue = int.tryParse(parsed.colOperand) ?? 0 & 0xFFFFFF;
    final objectCode = operandValue.toRadixString(16).padLeft(6, '0');
    context.pushTextRecordPart(objectCode, parsed);
  }
}

class ObjectCodeBuilderDirectiveRes extends ObjectCodeBuilder {
  ObjectCodeBuilderDirectiveRes({required super.parsed});

  @override
  build(ObjectCodeBuilderContext context) {
    TextRecord tr = context.records.last as TextRecord;
    if (tr.length != 0) {
      tr = TextRecord();
      context.records.add(tr);
      print("split new textRecord");
    }
    print("update last startingAddress");
    tr.startingAddress = parsed.locctr.toRadixString(16).padLeft(6, '0');
  }
}

class ObjectCodeBuilderContext {
  List<ObjectProgramRecord> records = [];
  final Map<String, int> symtab;
  final int programLenth;

  ObjectCodeBuilderContext({
    required this.symtab,
    required this.programLenth,
  }) {
    print(symtab);
  }

  /// make a ~~line~~ record break for reserverd space.
  recoradBreak() {
    TextRecord tr = records.last as TextRecord;
    // A break will renew a text record once.
    if (tr.length != 0) {
      tr = TextRecord();
      records.add(tr);
    }
  }

  pushTextRecordPart(
    String objectCode,
    LlbAssemblerLineParser parsed,
  ) {
    TextRecord tr = records.last as TextRecord;
    if (tr.length == 0) {
      tr.startingAddress = parsed.locctr.toRadixString(16).padLeft(6, '0');
    }
    if (!tr.add(ObjectCodeBlock(
      string: objectCode,
      src: parsed.line,
    ))) {
      tr = TextRecord();
      tr.startingAddress = parsed.locctr.toRadixString(16).padLeft(6, '0');
      tr.add(ObjectCodeBlock(
        string: objectCode,
        src: parsed.line,
      ));
      records.add(tr);
    }
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
