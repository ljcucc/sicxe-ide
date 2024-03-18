import 'package:flutter/material.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/emulator_clock_adjust.dart';
import 'package:sicxe/widgets/top_segmented_buttons/top_segmented_buttons.dart';
import 'package:sicxe/widgets/top_segmented_buttons/top_segmented_buttons_group.dart';

class NavigationPageTopSegmentedButtonGroup extends StatelessWidget {
  final NavigationPageId pageId;

  const NavigationPageTopSegmentedButtonGroup(
      {super.key, required this.pageId});

  @override
  Widget build(BuildContext context) {
    final centerButtons = [
      TopSegmentedActionButtonData(id: "emulator_play"),
      TopSegmentedNumberDisplayData(
        title: "Program Counter",
        key: "pc",
      ),
      TopSegmentedNumberDisplayData(
        title: "opcode",
        key: "opcode",
      ),
      TopSegmentedActionButtonData(id: "emulator_clock"),
      TopSegmentedActionButtonData(id: "timeline_step"),
    ];

    List<TopSegmentedButtonData> sideButton = switch (pageId) {
      // TODO: Handle this case.
      NavigationPageId.Home => [],
      // TODO: Handle this case.
      NavigationPageId.Assets => [
          TopSegmentedActionButtonData(id: "file_import"),
          TopSegmentedActionButtonData(id: "file_new"),
        ],
      NavigationPageId.Timeline => [],
      NavigationPageId.Terminal => [
          TopSegmentedActionButtonData(id: "terminal_clear"),
        ],
      NavigationPageId.Editor => [
          // TopSegmentedActionButtonData(id: "file_new"),
          TopSegmentedActionButtonData(id: "editor_build"),
          TopSegmentedActionButtonData(id: "editor_upload"),
          TopSegmentedActionButtonData(id: "editor_format"),
        ],
    };

    return TopSegmentedButtonsGroup(children: [
      if (sideButton.isNotEmpty) TopSegmentedButtons(buttons: sideButton),
      TopSegmentedButtons(buttons: centerButtons),
      if (pageId == NavigationPageId.Timeline)
        TopSegmentedButtons(buttons: [
          TopSegmentedActionButtonData(id: "timeline_record"),
          TopSegmentedNumberDisplayData(
            title: "Snapshot Length",
            key: "snapshot_length",
          ),
          TopSegmentedActionButtonData(id: "timeline_scale"),
          TopSegmentedActionButtonData(id: "timeline_reset"),
        ])
    ]);
  }
}
