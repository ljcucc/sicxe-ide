import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class EmulatorPlayButton extends StatelessWidget {
  const EmulatorPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, child) {
      return Consumer<EmulatorWorkflow>(
        builder: (context, emulator, child) {
          return InkWell(
            onTap: () {
              if (emulator.isLoopRunning()) {
                emulator.stopEvalLoop();
              } else {
                emulator.evalLoop(tdlp);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(14.0),
              child: Icon(
                emulator.isLoopRunning()
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
            ),
          );
        },
      );
    });
  }
}
