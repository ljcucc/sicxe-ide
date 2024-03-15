import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/widgets/top_segmented_buttons/number_display.dart';

class TimelineSnapshotLengthDisplay extends StatelessWidget {
  const TimelineSnapshotLengthDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
      return NumberDisplay(
        title: "Snapshot Length",
        value: tdlp.totalLength.toString(),
      );
    });
  }
}
