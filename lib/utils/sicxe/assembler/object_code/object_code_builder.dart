import 'package:flutter/material.dart';
import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/assembler/object_program_record.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';
import 'package:sicxe/utils/sicxe/assembler/object_code/object_code_instruction.dart';

String toFixedHexString({required int value, int pad = 2}) {
  return value.toRadixString(16).padLeft(pad, '0');
}

abstract class ObjectCodeBuilder {
  LineParserContext parserContext;

  ObjectCodeBuilder({required this.parserContext});

  build(ObjectCodeBuilderContext context);

  static resolve(LineParserContext context) {
    final opcode = LineParserOpcode(context: context).opcode;

    if (opcode != OpCodes.OP_NOT_FOUND) {
      return ObjectCodeBuilderInstruction(parserContext: context);
    }
    if (context.directiveType == LlbAssemblerDirectiveType.START) {
      return ObjectCodeBuilderDirectiveStart(parserContext: context);
    }
    if (context.directiveType == LlbAssemblerDirectiveType.BYTE) {
      return ObjectCodeBuilderDirectiveByte(parserContext: context);
    }
    if (context.directiveType == LlbAssemblerDirectiveType.WORD) {
      return ObjectCodeBuilderDirectiveWord(parserContext: context);
    }
    if (context.directiveType == LlbAssemblerDirectiveType.RESW ||
        context.directiveType == LlbAssemblerDirectiveType.RESB) {
      return ObjectCodeBuilderDirectiveRes(parserContext: context);
    }
  }
}

class ObjectCodeBuilderDirectiveStart extends ObjectCodeBuilder {
  ObjectCodeBuilderDirectiveStart({required super.parserContext});

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
  ObjectCodeBuilderDirectiveByte({required super.parserContext});

  @override
  build(ObjectCodeBuilderContext context) {
    final colOperand = parserContext.colOperand;
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

    context.pushTextRecordPart(objectCode, parserContext);
  }
}

class ObjectCodeBuilderDirectiveWord extends ObjectCodeBuilder {
  ObjectCodeBuilderDirectiveWord({required super.parserContext});

  @override
  build(ObjectCodeBuilderContext context) {
    final operandValue = int.tryParse(parserContext.colOperand) ?? 0 & 0xFFFFFF;
    final objectCode = operandValue.toRadixString(16).padLeft(6, '0');
    context.pushTextRecordPart(objectCode, parserContext);
  }
}

class ObjectCodeBuilderDirectiveRes extends ObjectCodeBuilder {
  ObjectCodeBuilderDirectiveRes({required super.parserContext});

  @override
  build(ObjectCodeBuilderContext context) {
    TextRecord tr = context.records.last as TextRecord;
    if (tr.length != 0) {
      tr = TextRecord();
      context.records.add(tr);
      print("split new textRecord");
    }
    print("update last startingAddress");
    tr.startingAddress = parserContext.locctr.toRadixString(16).padLeft(6, '0');
  }
}

class ObjectCodeBuilderContext {
  List<ModificationRecord> modiRecords = [];
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
    LineParserContext parserContext,
  ) {
    TextRecord tr = records.last as TextRecord;
    if (tr.length == 0) {
      tr.startingAddress =
          parserContext.locctr.toRadixString(16).padLeft(6, '0');
    }
    if (!tr.add(ObjectCodeBlock(
      string: objectCode,
      src: parserContext.line,
    ))) {
      tr = TextRecord();
      tr.startingAddress =
          parserContext.locctr.toRadixString(16).padLeft(6, '0');
      tr.add(ObjectCodeBlock(
        string: objectCode,
        src: parserContext.line,
      ));
      records.add(tr);
    }
  }

  ending(int startingLoc) {
    if ((records.last as TextRecord).length == 0) {
      records.removeLast();
    }

    records.addAll(modiRecords);

    final er = EndRecord();
    er.bootAddress = startingLoc.toRadixString(16).padLeft(6, '0');
    records.add(er);
  }
}
