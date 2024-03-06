import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_widget.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/screen_size.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_controller.dart';
import 'package:sicxe/widgets/side_panel/side_panel_controller.dart';

class TimingControlBarPanel extends StatefulWidget {
  const TimingControlBarPanel({super.key});

  @override
  State<TimingControlBarPanel> createState() => _TimingControlBarPanelState();
}

class _TimingControlBarPanelState extends State<TimingControlBarPanel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenSize>(builder: (context, screenSize, _) {
      return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
        return Consumer<EmulatorWorkflow>(
          builder: (context, emulator, child) {
            final center = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  onPressed: () async {
                    await emulator.eval();
                    tdlp.add(
                      emulator.toTimelineMap(),
                    );
                  },
                  tooltip: 'Step',
                  icon: const Icon(Icons.airline_stops),
                ),
                SizedBox(width: 16),
                IconButton(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  onPressed: () {
                    if (emulator.isLoopRunning()) {
                      emulator.stopEvalLoop();
                    } else {
                      emulator.evalLoop(tdlp);
                    }
                  },
                  tooltip: 'Continious',
                  icon: Icon(
                    emulator.isLoopRunning() ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  onPressed: () {},
                  tooltip: 'Speed up',
                  icon: const Icon(Icons.fast_forward),
                ),
              ],
            );

            final left = Row(
              mainAxisSize: MainAxisSize.min,
            );
            final right = Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  onPressed: () {
                    tdlp.reset();
                  },
                  tooltip: 'Clear',
                  icon: const Icon(Icons.clear_all),
                ),
                SizedBox(width: 16),
                TimelineScaleWidget(),
                // SizedBox(width: 16),
              ],
            );

            if (screenSize == ScreenSize.Compact) {
              return Center(
                child: SafeArea(
                  minimum: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      left,
                      SizedBox(width: 16),
                      center,
                      SizedBox(width: 16),
                      right,
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: left,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: center,
                    ),
                    Flexible(
                      flex: 1,
                      child: right,
                      fit: FlexFit.tight,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
    });
  }
}
