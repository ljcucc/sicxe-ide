import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sicxe/binary_bar.dart';
import 'package:sicxe/description_dialog.dart';
import 'package:sicxe/document_page/documents.dart';
import 'package:sicxe/overview_card.dart';
import 'package:sicxe/value_block.dart';
import 'package:sicxe/vm/vm.dart';

class InstructionInspector extends StatelessWidget {
  final SICXE vm;

  const InstructionInspector({super.key, required this.vm});

  _flags2disp(TargetAddress? ta) {
    String disp = "";
    if (ta == null) return disp;

    disp += ta.n ? "n" : "_";
    disp += ta.i ? "i" : "_";
    disp += ta.x ? "x" : "_";
    disp += ta.b ? "b" : "_";
    disp += ta.p ? "p" : "_";
    disp += ta.e ? "e" : "_";

    return disp;
  }

  @override
  Widget build(BuildContext context) {
    print(vm.curInstruction);

    return OverviewCard(
      title: Text("Instruction"),
      description: FutureBuilder(
        future: getDocument("instructions.md"),
        builder: (context, snapshot) {
          return DescriptionDialog(
            title: "指令",
            markdown: snapshot.data ?? "",
          );
        },
      ),
      child: Container(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 16,
          spacing: 16,
          children: [
            SizedBox(
              width: 450,
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      vm.curInstruction?.opcode.name ?? "¯\\_(ツ)_/¯",
                      style: Theme.of(context).textTheme.displayMedium,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(vm.curInstruction?.format.name ?? "What do you think?"),
                  SizedBox(height: 16),
                  BinaryBarView(
                    values: (vm.curInstruction?.bytes ?? Uint8List(1)),
                    showNumbers: true,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueBlock(title: "TargetAddress", disp: ""),
                  SizedBox(width: 8),
                  ValueBlock(
                    title: "Flags",
                    disp: _flags2disp(vm.ta),
                  ),
                  SizedBox(width: 8),
                  ValueBlock(title: "Address mode", disp: ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}