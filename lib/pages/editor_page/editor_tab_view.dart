import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/editor_tab_controller.dart';
import 'package:sicxe/pages/editor_page/tabs/csv_viewer_tab.dart';
import 'package:sicxe/pages/editor_page/tabs/text_editor_tab.dart';
import 'package:sicxe/pages/editor_page/tabs/vobj_viewer_tab/vobj_viewer_tab.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class EditorTabView extends StatelessWidget {
  const EditorTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      return Consumer<EditorTabController>(
        builder: (context, etc, _) {
          if (etc.tabId.endsWith(".asm")) {
            return TextEditorTab(
              key: Key(etc.tabId),
              filename: etc.tabId,
              text: editor.contents[etc.tabId] ?? "",
              onChange: (e) {
                editor.contents[etc.tabId] = e;
              },
            );
          }
          if (etc.tabId.endsWith(".vobj")) {
            return VobjViewerTab(filename: etc.tabId);
          }
          if (etc.tabId.endsWith(".csv")) {
            return CsvViewerTab(filename: etc.tabId);
          }
          return Container();
        },
      );
    });
  }
}
