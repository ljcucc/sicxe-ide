import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/top_segmented_buttons/number_display.dart';

class EmulatorTimelineMapValueDisplay extends StatelessWidget {
  final String title;
  final String mapKey;

  const EmulatorTimelineMapValueDisplay({
    super.key,
    required this.title,
    required this.mapKey,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(
      builder: (context, emulator, _) {
        return NumberDisplay(
          title: title,
          value: emulator.toTimelineMap()[mapKey] ?? "",
        );
      },
    );
  }
}
