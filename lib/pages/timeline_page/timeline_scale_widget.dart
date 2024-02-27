import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/screen_size.dart';

class TimelineScaleWidget extends StatelessWidget {
  const TimelineScaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      return Consumer<ScreenSize>(builder: (context, screenSize, _) {
        if (screenSize == ScreenSize.Compact) {
          return FilledButton.icon(
            style: FilledButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              tsc.scale = (tsc.scale + 1) % 3;
            },
            icon: Icon(Icons.zoom_in),
            label: Text(switch (tsc.scale) {
              0 => "x0.5",
              1 => "x1",
              2 => "x2",
              int() => "uwu"
            }),
          );
        }

        return Row(
          children: [
            for (final (name, value) in [
              ("x0.5", 0),
              ("x1", 1),
              ("x2", 2),
            ])
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: FilledButton(
                  style: tsc.scale == value
                      ? FilledButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                        )
                      : FilledButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(.35),
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                        ),
                  onPressed: () {
                    tsc.scale = value;
                  },
                  child: Text(name),
                ),
              ),
          ],
        );
      });
    });
  }
}
