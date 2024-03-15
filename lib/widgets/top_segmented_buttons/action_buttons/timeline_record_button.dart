import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';

class TimelineRecordButton extends StatelessWidget {
  const TimelineRecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineDataListsProvider>(
      builder: (context, tdlp, _) {
        return InkWell(
          onTap: () {
            tdlp.enable = !tdlp.enable;
          },
          child: Container(
            padding: const EdgeInsets.all(14.0),
            child: tdlp.enable
                ? Icon(
                    Icons.radio_button_checked,
                    color: Colors.red
                        .harmonizeWith(Theme.of(context).colorScheme.primary),
                  )
                : Icon(Icons.radio_button_checked),
          ),
        );
      },
    );
  }
}
