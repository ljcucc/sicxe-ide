import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timeline_track_card/timeline_track_cardview.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';

class TimelineTrackCardList extends StatelessWidget {
  const TimelineTrackCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final title in tdlp.lists.keys)
              TimelineTrackCardView(title: title),
          ],
        );
      });
    });
  }
}
