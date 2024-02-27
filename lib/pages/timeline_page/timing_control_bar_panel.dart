import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/playground_page/sicxe_vm_provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_widget.dart';
import 'package:sicxe/pages/timeline_page/timeline_snapshot_provider.dart';
import 'package:sicxe/utils/vm/vm.dart';

class TimingControlBarPanel extends StatefulWidget {
  const TimingControlBarPanel({super.key});

  @override
  State<TimingControlBarPanel> createState() => _TimingControlBarPanelState();
}

class _TimingControlBarPanelState extends State<TimingControlBarPanel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineSnapshotProvider>(builder: (context, tsp, _) {
      return Consumer<SicxeVmProvider>(
        builder: (context, svp, child) {
          final vm = svp.vm;
          final center = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                onPressed: () async {
                  await vm.eval();
                  svp.update();
                  tsp.push(vm.snapshot());
                },
                tooltip: 'Step',
                icon: const Icon(Icons.airline_stops),
              ),
              SizedBox(width: 16),
              IconButton(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                onPressed: () {},
                tooltip: 'Continious',
                icon: const Icon(Icons.play_arrow),
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

          return Center(
            child: SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 4,
                    child: center,
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    onPressed: () {
                      tsp.snapshots = [];
                      tsp.notifyListeners();
                    },
                    tooltip: 'Clear',
                    icon: const Icon(Icons.clear_all),
                  ),
                  SizedBox(width: 16),
                  TimelineScaleWidget(),
                  SizedBox(width: 16),
                  PopupMenuButton(itemBuilder: (_) => []),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
