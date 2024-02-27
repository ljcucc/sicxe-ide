import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar_controller.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar_panel.dart';

class TimingControlBar extends StatelessWidget {
  final bool compact;

  const TimingControlBar({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final double height = compact ? 80 : 92;
    return Consumer<TimingControlBarController>(builder: (context, tcb, _) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutQuart,
        height: tcb.enable ? height : 0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  // minimum: EdgeInsets.all(12),
                  child: TimingControlBarPanel(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
