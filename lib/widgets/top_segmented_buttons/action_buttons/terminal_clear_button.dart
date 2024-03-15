import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class TerminalClearButton extends StatelessWidget {
  const TerminalClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(
      builder: (context, emulator, child) {
        return InkWell(
          onTap: () {
            emulator.termianl.buffer.clear();
            emulator.termianl.setCursor(0, 0);
            emulator.notifyListeners();
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Icon(Icons.delete_outline),
          ),
        );
      },
    );
  }
}
