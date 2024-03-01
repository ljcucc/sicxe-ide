import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';

class TimelineTrackSizedBox extends StatelessWidget {
  final Widget child;

  const TimelineTrackSizedBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      return SizedBox(
        height: tsc.totalHeight,
        child: child,
      );
    });
  }
}
