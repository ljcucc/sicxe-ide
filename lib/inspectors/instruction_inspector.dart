import 'package:flutter/material.dart';
import 'package:sicxe/binary_bar.dart';
import 'package:sicxe/vm/vm.dart';

class InstructionInspector extends StatelessWidget {
  final SICXE vm;

  const InstructionInspector({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    print(vm.curInstruction);
    return Card(
      shadowColor: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: ListTile(
                title: const Text("Instruction overview"),
                subtitle: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        vm.curInstruction?.opcode.name ?? "¯\\_(ツ)_/¯",
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(vm.curInstruction?.format.name ??
                          "What do you think?"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BinaryBarView(
                  binary: vm.curInstruction?.bytes
                          .toList()
                          .map((e) => e.toRadixString(2).padLeft(8, '0'))
                          .join()
                          .padLeft(vm.curInstruction?.bytes.length ?? 0, '0') ??
                      "0",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
