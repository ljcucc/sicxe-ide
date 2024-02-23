import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/object_code_visualize_provider.dart';
import 'package:sicxe/utils/vm/op_code.dart';

typedef AssembleFunction = String Function(int operand);

// Map<OpCodes, AssembleFunction>

/// LlbAssembler is a assembler designed by Leland L. Beck
/// in Book "System Software - An Introduction to Systme Programming"
class LlbAssembler {
  final String text;
  Map<String, int> symtab = {};
  List<ObjectProgramRecord> records = [];

  int startingLoc = 0;
  int locctr = 0;

  LlbAssembler({required this.text});

  pass1() {
    symtab = {};
    List<String> lines = text.split("\n");
    locctr = 0;
    startingLoc = 0;
    for (final (index, line) in lines.indexed) {
      if (line.isEmpty) continue;
      if (line[0] == ".") continue; // is comment line

      List<String> cols =
          line.split(" ").where((element) => element.isNotEmpty).toList();

      // fetch label from cols
      String colLabel = "";

      bool hasLabel = line[0] != " ";
      if (hasLabel) {
        colLabel = cols.removeAt(0).toUpperCase();
      }

      // fetch opcode & operand
      String colOpcode = cols[0].toUpperCase();
      String colOperand = cols.length > 1 ? cols[1] : "";

      // starting line detection
      if (index == 0 && colOpcode == "START") {
        locctr = int.tryParse(colOperand, radix: 16) ?? 0;
        startingLoc = locctr;
      }

      // symbol detection
      if (hasLabel) {
        if (symtab.containsKey(colLabel)) throw "duplicate symbol: $colLabel";

        symtab[colLabel] = locctr;
        print("added $colLabel to symtab");
      }

      // constants & reserved detection
      if (OpCodes.values.map((e) => e.name).contains(colOpcode)) {
        // TODO: Adopt by instruction length in SIC/XE
        locctr += 3;
      } else if (colOpcode == "WORD") {
        locctr += 3;
      } else if (colOpcode == "RESW") {
        locctr += 3 * (int.tryParse(colOperand, radix: 10) ?? 0);
      } else if (colOpcode == "RESB") {
        locctr += int.tryParse(colOperand, radix: 10) ?? 0;
      } else if (colOpcode == "BYTE") {
        final segments = colOperand.split('\'');
        if (segments[0] == 'X') {
          // final val = int.tryParse(segments[1]) ?? 0;
          locctr += 1;
        }
        if (segments[0] == 'C') {
          locctr += segments[1].length;
        }
      }
    }
  }

  pass2() {
    records = [];
    List<String> lines = text.split("\n");
    for (final (index, line) in lines.indexed) {
      if (line.isEmpty) continue;
      if (line[0] == ".") continue; // is comment line

      List<String> cols =
          line.split(" ").where((element) => element.isNotEmpty).toList();

      // fetch label from cols
      String colLabel = "";

      bool hasLabel = line[0] != " ";
      if (hasLabel) {
        colLabel = cols.removeAt(0).toUpperCase();
      }

      // fetch opcode & operand
      String colOpcode = cols[0].toUpperCase();
      String colOperand = cols.length > 1 ? cols[1] : "";

      if (index == 0 && colOpcode.toUpperCase() == "START") {
        final header = HeaderRecord();
        header.programName = symtab.entries.first.key.padRight(6);
        header.length = (locctr - startingLoc)
            .toRadixString(16)
            .padLeft(6, '0')
            .toUpperCase();
        header.startingAddress = symtab.entries.first.value
            .toRadixString(16)
            .padLeft(6, '0')
            .toUpperCase();
        records.add(header);

        var tr = TextRecord();
        records.add(tr);

        // reset locctr for object program generate
        locctr = startingLoc;
        continue;
      }

      if (OpCodes.values.map((e) => e.name).contains(colOpcode)) {
        int operandValue = 0;
        if (colOperand.isNotEmpty &&
            !symtab.containsKey(colOperand.replaceAll(",X", "")))
          throw "undefined symbol: $colOperand";

        operandValue = symtab[colOperand.replaceAll(",X", "")] ?? 0;

        // handle flag X
        if (colOperand.endsWith(",X")) {
          operandValue |= 0x8000;
        }

        final opcodeHex = DecodeTable.keys
            .firstWhere((key) => DecodeTable[key]?.name == colOpcode)
            .toRadixString(16)
            .padLeft(2, '0');
        final operandHex = operandValue.toRadixString(16).padLeft(4, '0');
        final objectCode = "$opcodeHex$operandHex";

        TextRecord tr = records.last as TextRecord;
        if (tr.length == 0) {
          tr.startingAddress = locctr.toRadixString(16).padLeft(6, '0');
        }
        if (!tr.add(objectCode)) {
          tr = TextRecord();
          tr.startingAddress = locctr.toRadixString(16).padLeft(6, '0');
          tr.add(objectCode);
          records.add(tr);
        }
      } else if (colOpcode == "BYTE") {
        var objectCode = "";
        if (colOperand[0] == 'X') {
          final operandValue =
              int.tryParse(colOperand.split("'")[1], radix: 16) ?? 0;
          objectCode = operandValue.toRadixString(16).padLeft(2, '0');
        } else if (colOperand[0] == 'C') {
          objectCode = colOperand
              .split("'")[1]
              .characters
              .map((e) => e.codeUnitAt(0).toRadixString(16).padLeft(2, '0'))
              .join();
          print("BYTE $colOperand': $objectCode");
        }
        _appendToRecord(objectCode);
      } else if (colOpcode == "WORD") {
        final operandValue = int.tryParse(colOperand) ?? 0 & 0xFFFFFF;
        final objectCode = operandValue.toRadixString(16).padLeft(6, '0');
        _appendToRecord(objectCode);
      } else if (colOpcode == "RESW" || colOpcode == "RESB") {
        TextRecord tr = records.last as TextRecord;
        if (tr.length != 0) {
          tr = TextRecord();
          records.add(tr);
          print("split new textRecord");
        }
        print("update last startingAddress");
        tr.startingAddress = locctr.toRadixString(16).padLeft(6, '0');
      }

      // constants & reserved detection
      if (OpCodes.values.map((e) => e.name).contains(colOpcode)) {
        // TODO: Adopt by instruction length in SIC/XE
        locctr += 3;
      } else if (colOpcode == "WORD") {
        locctr += 3;
      } else if (colOpcode == "RESW") {
        locctr += 3 * (int.tryParse(colOperand, radix: 10) ?? 0);
      } else if (colOpcode == "RESB") {
        locctr += int.tryParse(colOperand, radix: 10) ?? 0;
      } else if (colOpcode == "BYTE") {
        final segments = colOperand.split('\'');
        if (segments[0] == 'X') {
          // final val = int.tryParse(segments[1]) ?? 0;
          locctr += 1;
        }
        if (segments[0] == 'C') {
          locctr += segments[1].length;
        }
      }
    }
  }

  _appendToRecord(String objectCode) {
    TextRecord tr = records.last as TextRecord;
    if (tr.length == 0) {
      tr.startingAddress = locctr.toRadixString(16).padLeft(6, '0');
    }
    if (!tr.add(objectCode)) {
      tr = TextRecord();
      tr.startingAddress = locctr.toRadixString(16).padLeft(6, '0');
      tr.add(objectCode);
      records.add(tr);
    }
  }

  compile() {}
}

abstract class ObjectProgramRecord {
  String getRecord();
  Widget getInteractiveDisp();
}

class HeaderRecord extends ObjectProgramRecord {
  String programName = "";
  String startingAddress = "";
  String length = "";

  @override
  String getRecord() {
    return "H$programName$startingAddress$length\n";
  }

  @override
  Widget getInteractiveDisp() {
    return Builder(builder: (context) {
      return Row(
        children: [
          SuggestableText(
            message: "Header char, for HeaderRecord is [T]",
            text: "H",
            color: Colors.green[800],
          ),
          SuggestableText(
            message: "Program name",
            text: programName,
            color: Colors.green[800],
          ),
          SuggestableText(
            message: "Staring address of object program.",
            text: startingAddress,
            color: Colors.green[800],
          ),
          SuggestableText(
            message: "Length of object program in bytes.",
            text: length,
            color: Colors.green[800],
          ),
        ],
      );
    });
  }
}

class TextRecord extends ObjectProgramRecord {
  String startingAddress = "000000";
  List<String> blocks = [];

  bool add(String objectCode) {
    if (length + objectCode.length > 60) return false;

    blocks.add(objectCode);
    return true;
  }

  int get length {
    if (blocks.isEmpty) return 0;
    int totalLength = blocks
        .map<int>((e) => e.length)
        .reduce((value, element) => value + element);
    return totalLength;
  }

  String get lengthString {
    return (length ~/ 2).toRadixString(16).padLeft(2, '0');
  }

  @override
  String getRecord() {
    var objectCodeString = blocks.join();
    return "T$startingAddress$lengthString$objectCodeString\n".toUpperCase();
  }

  @override
  Widget getInteractiveDisp() {
    return Row(
      children: [
        SuggestableText(
            message: "Heading char, for TextRecord is [T]", text: "T"),
        SuggestableText(
            message: "Starting address for object code in this record.",
            text: startingAddress),
        SuggestableText(
            message: "Length of object code in this record in bytes",
            text: lengthString),
        for (final block in blocks)
          SuggestableText(message: "Object code: $block", text: block),
      ],
    );
  }
}

class EndRecord extends ObjectProgramRecord {
  String bootAddress = "";

  @override
  String getRecord() {
    return "E$bootAddress\n";
  }

  @override
  Widget getInteractiveDisp() {
    return Text(getRecord());
  }
}

class SuggestableText extends StatelessWidget {
  final String message;
  final String text;
  final Color? color;

  const SuggestableText({
    super.key,
    required this.message,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final objectCodeIsVisualized = context.watch<ObjectCodeIsVisualized>();
    final isVisualized = objectCodeIsVisualized.visualized;
    final body = InkWell(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCirc,
        padding: EdgeInsets.all(isVisualized ? 8 : 0),
        margin: EdgeInsets.all(isVisualized ? 2 : 0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isVisualized
              ? Theme.of(context)
                  .colorScheme
                  .surfaceTint
                  .harmonizeWith(
                    color ?? Theme.of(context).colorScheme.surfaceTint,
                  )
                  .withOpacity(.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.spaceMono().copyWith(
            color: color != null
                ? Theme.of(context).colorScheme.primary.harmonizeWith(color!)
                : null,
          ),
        ),
      ),
    );

    return Builder(builder: (context) {
      return Tooltip(
        message: message,
        child: body,
      );
    });
  }
}
