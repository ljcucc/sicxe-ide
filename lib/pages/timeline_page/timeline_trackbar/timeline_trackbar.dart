import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_data_list.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timeline_trackbar/timeline_trackbar_block_view.dart';
import 'package:sicxe/pages/timeline_page/timeline_track_sized_box.dart';

/// This widget provided to render track of blocks
class TimelineTrackbar extends StatelessWidget {
  final TimelineDataList list;
  const TimelineTrackbar({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: tsc.fixedBottomMargin,
        ),
        child: TimelineTrackSizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              top: tsc.fixedTopPadding,
              bottom: tsc.fixedBottomPadding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final data in list.blocks)
                  TimelineTrackBlockBlockView(data: data),
              ],
            ),
          ),
        ),
      );
    });
  }
}
