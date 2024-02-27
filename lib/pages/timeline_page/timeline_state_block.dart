import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';

/// This is a widget that showing the machine state in time
class TimelineStateBlock extends StatelessWidget {
  final bool enable;
  final String text;
  final Color? color;

  const TimelineStateBlock({
    super.key,
    this.color,
    required this.text,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      return Padding(
        padding: const EdgeInsets.only(right: 2.0),
        // padding: EdgeInsets.zero,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: primaryColor
                .harmonizeWith(color ?? primaryColor)
                .withOpacity(this.enable ? 1 : 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutQuart,
          height: tsc.smallView ? 40 : 80,
          width: tsc.smallView ? 50 : 100,
          // color: Theme.of(context).colorScheme.primaryContainer,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.spaceMono(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: tsc.smallView ? 13 : 16),
            ),
          ),
        ),
      );
    });
  }
}
