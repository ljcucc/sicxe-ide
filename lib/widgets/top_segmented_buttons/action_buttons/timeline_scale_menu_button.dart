import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/widgets/top_segmented_buttons/number_display.dart';

class TimelineScaleMenuButton extends StatelessWidget {
  const TimelineScaleMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(
      builder: (context, tsc, _) {
        return PopupMenuButton(
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
            padding: EdgeInsets.symmetric(vertical: 8),
            child: NumberDisplay(
              title: "scale",
              value: switch (tsc.scale) {
                0 => "x0.5",
                1 => "x1",
                2 => "x2",
                int() => "uwu"
              },
            ),
          ),
        );
      },
    );
  }
}
