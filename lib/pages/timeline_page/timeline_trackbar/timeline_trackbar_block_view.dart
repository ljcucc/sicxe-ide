import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_data_list.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';

/// This widget provided to render a single block on track
class TimelineTrackBlockBlockView extends StatelessWidget {
  final TimelineDataBlock data;
  final Color? color;

  const TimelineTrackBlockBlockView({
    super.key,
    required this.data,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      final width =
          data.length * tsc.blockWidth + (data.length - 1) * tsc.afterPadding;
      return Padding(
        padding: EdgeInsets.only(left: tsc.afterPadding),
        child: Tooltip(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          message: "raw: ${data.value}",
          padding: EdgeInsets.all(16),
          textStyle: GoogleFonts.robotoMono(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          verticalOffset: tsc.blockHeight / 2 + 8,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 550),
            curve: Curves.easeInOutQuart,
            width: width,
            height: tsc.blockHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color != null
                  ? Theme.of(context).colorScheme.primary.harmonizeWith(color!)
                  : Theme.of(context).colorScheme.secondary,
              // .harmonizeWith(Colors.transparent),
            ),
            child: width < 50
                ? Container()
                : Center(
                    child: Text(
                      data.value,
                      style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
