import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class TimeControlSegmentedButtons extends StatelessWidget {
  const TimeControlSegmentedButtons({super.key});

  _numberDisplay(String title, String value) {
    return Container(
      width: 100,
      child: Column(
        children: [
          Center(
            child: Text(
              value,
              style: GoogleFonts.robotoMono(),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 8),
          ),
        ],
      ),
    );
  }

  _scaleController() {
    return Consumer<TimelineScaleController>(
      builder: (context, tsc, _) {
        return PopupMenuButton(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          position: PopupMenuPosition.under,
          itemBuilder: (_) => [
            PopupMenuItem(
              onTap: () => tsc.scale = 0,
              child: ListTile(
                title: Text("0.5"),
                subtitle: Text("Detailid view"),
              ),
            ),
            PopupMenuItem(
              onTap: () => tsc.scale = 1,
              child: ListTile(
                title: Text("1"),
                subtitle: Text("Normal view"),
              ),
            ),
            PopupMenuItem(
              onTap: () => tsc.scale = 2,
              child: ListTile(
                title: Text("2"),
                subtitle: Text("Small possible"),
              ),
            ),
          ],
          child: Container(
            width: 60,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: _numberDisplay(
              "scale",
              switch (tsc.scale) {
                0 => "x0.5",
                1 => "x1",
                2 => "x2",
                int() => "uwu"
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
    final outlineColor = Theme.of(context).colorScheme.outline;

    final divider = () => Container(
          height: 30,
          width: 1,
          color: outlineColor,
        );

    return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
      return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
        return Material(
          color: backgroundColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
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
              ),
              divider(),
              InkWell(
                onTap: () async {
                  await emulator.eval();
                  tdlp.add(
                    emulator.toTimelineMap(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(Icons.airline_stops_outlined),
                ),
              ),
              divider(),
              _numberDisplay(
                "System Timer",
                tdlp.totalLength.toString(),
              ),
              divider(),
              _numberDisplay(
                "program counter",
                emulator.toTimelineMap()['pc'] ?? "",
              ),
              divider(),
              _numberDisplay(
                "opcode",
                emulator.toTimelineMap()['opcode'] ?? "",
              ),
              divider(),
              _scaleController(),
              divider(),
              InkWell(
                onTap: () {
                  tdlp.reset();
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(Icons.delete_outline),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
