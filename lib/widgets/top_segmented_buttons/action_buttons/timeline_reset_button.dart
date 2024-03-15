import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';

class TimelineResetButton extends StatelessWidget {
  const TimelineResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
      return InkWell(
        onTap: () {
          tdlp.reset();
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Icon(Icons.delete_outline),
        ),
      );
    });
  }
}
