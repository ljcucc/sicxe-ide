import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class TimelineStepButton extends StatelessWidget {
  const TimelineStepButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
      return Consumer<EmulatorWorkflow>(
        builder: (context, emulator, _) {
          return InkWell(
            onTap: () async {
              await emulator.eval();
              tdlp.add(
                emulator.toTimelineMap(),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Icon(Icons.airline_stops_outlined),
            ),
          );
        },
      );
    });
  }
}
