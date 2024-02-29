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
        if (screenSize != ScreenSize.Large) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: PopupMenuButton(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              position: PopupMenuPosition.under,
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () => tsc.scale = 0,
                  child: ListTile(
                    title: Text("0.5"),
                    subtitle: Text("Detailid view"),
                  ),
                ),
                PopupMenuItem(
                  onTap: () => tsc.scale = 1,
                  child: ListTile(
                    title: Text("1"),
                    subtitle: Text("Normal view"),
                  ),
                ),
                PopupMenuItem(
                  onTap: () => tsc.scale = 2,
                  child: ListTile(
                    title: Text("2"),
                    subtitle: Text("Small possible"),
                  ),
                ),
              ],
              child: Container(
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(.35),
                ),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  switch (tsc.scale) {
                    0 => "x0.5",
                    1 => "x1",
                    2 => "x2",
                    int() => "uwu"
                  },
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
