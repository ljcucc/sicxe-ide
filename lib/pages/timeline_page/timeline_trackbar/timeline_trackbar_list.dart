import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_linked_scroll_controller.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timeline_trackbar/timeline_trackbar.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';

class TimelineTrackbarList extends StatefulWidget {
  const TimelineTrackbarList({super.key});

  @override
  State<TimelineTrackbarList> createState() => _TimelineTrackbarListState();
}

class _TimelineTrackbarListState extends State<TimelineTrackbarList> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        Provider.of<LinkedScrollControllerGroup>(context, listen: false)
            .addAndGet();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
        return SingleChildScrollView(
          controller: _controller,
          padding: EdgeInsets.only(left: tsc.scrollLeftPadding),
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final list in tdlp.lists.values)
                TimelineTrackbar(list: list),
            ],
          ),
        );
      });
    });
  }
}
