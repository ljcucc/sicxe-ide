import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_ruler_widget.dart';
import 'package:sicxe/pages/timeline_page/timline_scrollview.dart';
import 'package:sicxe/screen_size.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenSize>(builder: (context, screenSize, _) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize == ScreenSize.Compact ? 0 : 16,
        ).copyWith(top: screenSize == ScreenSize.Compact ? 16 : null),
        child: Column(
          children: [
            TimelineRulerWidget(),
            SizedBox(height: 8),
            Expanded(
              child: TimelineScrollView(),
            )
          ],
        ),
      );
    });
  }
}
