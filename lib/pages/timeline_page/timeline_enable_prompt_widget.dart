import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';

class TimelineEnablePromptWidget extends StatelessWidget {
  const TimelineEnablePromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Theme.of(context).colorScheme.primary.withOpacity(.035),
              ),
              BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 20,
                color: Theme.of(context).colorScheme.primary.withOpacity(.05),
              )
            ],
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.graphic_eq_outlined),
                SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Click "),
                      WidgetSpan(
                        child: Icon(
                          Icons.radio_button_checked,
                          color: Colors.red.harmonizeWith(
                              Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      TextSpan(
                        text:
                            " to record realtime status into Timeline during runtime.\nOnce recorded and runtime started, snapshot will displayed in timeline.",
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    });
  }
}
