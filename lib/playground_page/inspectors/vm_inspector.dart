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
        minimum: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (size.width > 1000) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16).copyWith(right: 8),
                width: 400,
                height: double.infinity,
                child: MemoryInspector(mem: vm.mem),
              ),
            ],
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
