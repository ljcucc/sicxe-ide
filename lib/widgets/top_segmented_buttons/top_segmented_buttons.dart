import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/editor_build_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/editor_format_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/editor_upload_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/emulator_clock_adjust.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/emulator_play_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/file_import_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/file_new_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/terminal_clear_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/timeline_record_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/timeline_reset_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/timeline_scale_menu_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/action_buttons/timeline_step_button.dart';
import 'package:sicxe/widgets/top_segmented_buttons/number_display_buttons/emulator_timelinemap_value_display.dart';
import 'package:sicxe/widgets/top_segmented_buttons/number_display_buttons/timeline_snapshot_length_display.dart';

enum TopSegmentedButtonType {
  ActionButton,
  DisplayButton,
}

class TopSegmentedButtonData {}

class TopSegmentedActionButtonData implements TopSegmentedButtonData {
  final String id;
  TopSegmentedActionButtonData({
    required this.id,
  });
}

class TopSegmentedNumberDisplayData implements TopSegmentedButtonData {
  final String title;
  final String key;
  TopSegmentedNumberDisplayData({
    required this.title,
    required this.key,
  });
}

class TopSegmentedButtons extends StatelessWidget {
  final List<TopSegmentedButtonData> buttons;

  const TopSegmentedButtons({super.key, required this.buttons});

  _getActionWidget(TopSegmentedActionButtonData data) {
    return switch (data.id) {
      "emulator_play" => const EmulatorPlayButton(),
      "timeline_record" => const TimelineRecordButton(),
      "timeline_reset" => const TimelineResetButton(),
      "timeline_step" => const TimelineStepButton(),
      "timeline_scale" => const TimelineScaleMenuButton(),
      "file_new" => const FileNewButton(),
      "file_import" => const FileImportButton(),
      "editor_build" => const EditorBuildButton(),
      "editor_upload" => const EditorUploadButton(),
      "editor_format" => const EditorFormatButton(),
      "emulator_clock" => const EmulatorClockAdjustButton(),
      "terminal_clear" => const TerminalClearButton(),
      String() => Container(),
    };
  }

  _getNumberDisplayWidget(TopSegmentedNumberDisplayData data) {
    return switch (data.key) {
      "snapshot_length" => const TimelineSnapshotLengthDisplay(),
      String() => EmulatorTimelineMapValueDisplay(
          title: data.title,
          mapKey: data.key,
        ),
    };
  }

  Widget _getButtonWidget(TopSegmentedButtonData data) {
    if (data is TopSegmentedActionButtonData) {
      return _getActionWidget(data);
    }

    if (data is TopSegmentedNumberDisplayData) {
      return _getNumberDisplayWidget(data);
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
    final outlineColor = Theme.of(context).colorScheme.outline;

    divider() => Container(height: 30, width: 1, color: outlineColor);

    return Consumer<TimelineDataListsProvider>(builder: (context, tdlp, _) {
      return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
        return Material(
          color: backgroundColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (final (index, data) in buttons.indexed) ...[
                _getButtonWidget(data),
                if (index != buttons.length - 1) divider(),
              ],
            ],
          ),
        );
      });
    });
  }
}
