import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/playground_page/inspectors/instruction_inspector.dart';
import 'package:sicxe/pages/playground_page/inspectors/registers_inspector_list.dart';
import 'package:sicxe/utils/sicxe/emulator/vm.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class VMInspector extends StatelessWidget {
  final SICXE vm;
  const VMInspector({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: double.infinity),
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16)
                      .copyWith(bottom: 128),
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
    });
  }
}
