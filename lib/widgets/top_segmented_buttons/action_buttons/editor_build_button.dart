import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/editor_tab_controller.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class EditorBuildButton extends StatelessWidget {
  const EditorBuildButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      return Consumer<EditorTabController>(builder: (context, etc, _) {
        _onCompile() {
          editor.compile(etc.tabId);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content:
                  Text("Code is compiled, view the object code in its tab."),
              action: SnackBarAction(
                label: "View",
                onPressed: () {
                  final objfile = etc.tabId.split(".")[0] + ".vobj";
                  etc.tabId = objfile;
                },
              ),
            ),
          );
          etc.openTab(etc.tabId.split(".")[0] + ".vobj", setTab: false);
        }

        return Tooltip(
          message: "Build",
          child: InkWell(
            onTap: () => _onCompile(),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_outlined),
                  SizedBox(width: 8),
                  Text("Build"),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
