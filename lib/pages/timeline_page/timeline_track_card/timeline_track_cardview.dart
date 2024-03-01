import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timeline_track_sized_box.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/screen_size.dart';

class TimelineTrackCardView extends StatelessWidget {
  final String title;

  const TimelineTrackCardView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      return Consumer<ScreenSize>(builder: (context, screenSize, _) {
        return Padding(
          padding: EdgeInsets.only(bottom: tsc.fixedBottomMargin),
          child: TimelineTrackSizedBox(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(.5),
                borderRadius: BorderRadius.circular(
                    screenSize == ScreenSize.Compact ? 0 : 8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                    .copyWith(bottom: 8),
                child: Text(title),
              ),
            ),
          ),
        );
      });
    });
  }
}
