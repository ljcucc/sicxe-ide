import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/editor_tab_controller.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class EditorFormatButton extends StatelessWidget {
  const EditorFormatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      return Consumer<EditorTabController>(builder: (context, etc, _) {
        return InkWell(
          onTap: () {
            editor.format(etc.tabId);
            etc.update();
          },
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Icon(Icons.format_align_left),
          ),
        );
      });
    });
  }
}
