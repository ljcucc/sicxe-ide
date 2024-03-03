import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_track_card/timeline_track_cardlist.dart';
import 'package:sicxe/pages/timeline_page/timeline_trackbar/timeline_trackbar_list.dart';
import 'package:sicxe/screen_size.dart';

class TimelineScrollView extends StatelessWidget {
  const TimelineScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenSize>(builder: (context, screenSize, _) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(screenSize == ScreenSize.Compact ? 0 : 16)
                  .copyWith(
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              TimelineTrackCardList(),
              TimelineTrackbarList(),
            ],
          ),
        ),
      );
    });
  }
}
