import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sicxe/binary_bar.dart';
import 'package:sicxe/overview_card.dart';
import 'package:sicxe/vm/vm.dart';

class InstructionInspector extends StatelessWidget {
  final SICXE vm;

  const InstructionInspector({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    print(vm.curInstruction);

    return OverviewCard(
      title: Text("Instruction"),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vm.curInstruction?.opcode.name ?? "¯\\_(ツ)_/¯",
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          Text(vm.curInstruction?.format.name ?? "What do you think?"),
          SizedBox(height: 16),
          BinaryBarView(
            values: (vm.curInstruction?.bytes ?? Uint8List(1)),
            showNumbers: true,
          ),
        ],
      ),
    );
  }
}
