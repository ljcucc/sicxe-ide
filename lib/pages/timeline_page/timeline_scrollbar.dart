import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timeline_snapshot_provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_state_block.dart';
import 'package:sicxe/utils/vm/vm.dart';

class TimelineScrollBar extends StatefulWidget {
  final Color? color;
  final String title;
  final String? Function(int index, SICXE vm) itemBuilder;

  const TimelineScrollBar({
    super.key,
    required this.title,
    this.color,
    required this.itemBuilder,
  });

  @override
  State<TimelineScrollBar> createState() => _TimelineScrollBarState();
}

class _TimelineScrollBarState extends State<TimelineScrollBar> {
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
    Object? lastReuslt = null;
    int sameReusltCount = 0;
    return Consumer<TimelineSnapshotProvider>(builder: (context, tsp, _) {
      return Consumer<TimelineScaleController>(builder: (context, tsc, _) {
        final length = tsp.snapshots.length;
        return AnimatedContainer(
          duration: Duration(milliseconds: 550),
          curve: Curves.easeInOutQuart,
          height: tsc.smallView ? 120 : 120,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(0),
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.5),
            // border:
            //     Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
          ),
          padding: EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16)
                          .copyWith(bottom: 8),
                      child: Text(widget.title),
                    ),
                  ),
                  PopupMenuButton(
                    iconSize: 18,
                    itemBuilder: (_) => [],
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    final result =
                        widget.itemBuilder(index, tsp.snapshots[index]);

                    return TimelineStateBlock(
                      color: widget.color,
                      text: result ?? "",
                      enable: result != null,
                      // text: "0x${index.toRadixString(16).padLeft(2, '0')}",
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
