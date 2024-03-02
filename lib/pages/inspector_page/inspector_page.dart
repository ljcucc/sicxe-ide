import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/overview_card.dart';
import 'package:sicxe/widgets/value_block.dart';

class InspectorPage extends StatelessWidget {
  final EdgeInsets padding;
  const InspectorPage({
    super.key,
    this.padding = const EdgeInsets.only(right: 16, left: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(
      builder: (context, emulator, child) {
        final inspectorContent = emulator.toInspectorMap();

        return Padding(
          padding: padding,
          child: SingleChildScrollView(
            child: Column(children: [
              for (final key in inspectorContent.keys)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: OverviewCard(
                    title: Text(key),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final sectionKey in inspectorContent[key]!.keys)
                          ValueBlock(
                            title: sectionKey,
                            disp: inspectorContent[key]![sectionKey] ?? "",
                          )
                      ],
                    ),
                  ),
                ),
            ]),
          ),
        );
      },
    );
  }
}
