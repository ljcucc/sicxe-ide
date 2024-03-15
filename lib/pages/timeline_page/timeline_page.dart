import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_enable_prompt_widget.dart';
import 'package:sicxe/pages/timeline_page/timeline_ruler_widget.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/pages/timeline_page/timline_scrollview.dart';
import 'package:sicxe/screen_size.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenSize>(builder: (context, screenSize, _) {
      return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize == ScreenSize.Compact ? 0 : 16,
            vertical: 16,
          ),
          child: tdlp.totalLength > 0
              ? Column(
                  children: [
                    Expanded(
                      child: TimelineScrollView(),
                    ),
                    SizedBox(height: 8),
                    TimelineRulerWidget(),
                  ],
                )
              : TimelineEnablePromptWidget(),
        );
      });
    });
  }
}
