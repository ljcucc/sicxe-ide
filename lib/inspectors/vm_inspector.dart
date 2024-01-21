import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sicxe/inspectors/instruction_inspector.dart';
import 'package:sicxe/inspectors/memory_inspector.dart';
import 'package:sicxe/inspectors/registers_inspector_list/register_inspector.dart';
import 'package:sicxe/inspectors/registers_inspector_list/registers_inspector_list.dart';

import '../vm/vm.dart';

class VMInspector extends StatelessWidget {
  final SICXE vm;
  const VMInspector({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final children = [
      RegistersInspectorList(vm: vm),
      MemoryInspector(mem: vm.mem),
      InstructionInspector(vm: vm),
    ];

    Widget layout = GridView.count(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      crossAxisCount: max(1, MediaQuery.of(context).size.width ~/ 400),
      childAspectRatio: 4 / 5,
      children: children
          .map(
            (e) => SizedBox(
              height: 300,
              child: e,
            ),
          )
          .toList(),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: double.infinity),
      child: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegistersInspectorList(vm: vm),
                    SizedBox(height: 300, child: InstructionInspector(vm: vm)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(child: MemoryInspector(mem: vm.mem)),
          ],
        ),
      ),
    );
  }
}
