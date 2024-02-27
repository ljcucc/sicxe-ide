import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timeline_snapshot_provider.dart';

class TimelineRulerWidget extends StatefulWidget {
  const TimelineRulerWidget({super.key});

  @override
  State<TimelineRulerWidget> createState() => _TimelineRulerWidgetState();
}

class _TimelineRulerWidgetState extends State<TimelineRulerWidget> {
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();

    _controller =
        Provider.of<LinkedScrollControllerGroup>(context, listen: false)
            .addAndGet();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
      return Consumer<TimelineSnapshotProvider>(builder: (context, tsp, _) {
        return Container(
          height: 50,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            controller: _controller,
            itemCount: tsp.snapshots.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 550),
                    curve: Curves.easeInOutQuart,
                    width: (tsc.smallView ? 50 : 100),
                    height: 60,
                    child: Center(
                      child: Text(
                        tsp.snapshots[index].pc.get().toRadixString(16),
                        style: GoogleFonts.spaceMono(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.outline,
                    height: 30,
                    width: 2,
                  ),
                ],
              );
            },
          ),
        );
      });
    });
  }
}
