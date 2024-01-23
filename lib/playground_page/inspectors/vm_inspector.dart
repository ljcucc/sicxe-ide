import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sicxe/playground_page/inspectors/instruction_inspector.dart';
import 'package:sicxe/playground_page/inspectors/memory_inspector.dart';
import 'package:sicxe/playground_page/inspectors/registers_inspector_list.dart';
import 'package:sicxe/vm/vm.dart';

class VMInspector extends StatelessWidget {
  final SICXE vm;
  const VMInspector({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: double.infinity),
      child: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (size.width > 1000) ...[
              SizedBox(width: 400, child: MemoryInspector(mem: vm.mem)),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InstructionInspector(vm: vm),
                    RegistersInspectorList(vm: vm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
