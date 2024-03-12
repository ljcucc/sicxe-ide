import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class EditorButtons extends StatelessWidget {
  const EditorButtons({super.key});

  _onCompile(EditorWorkflow editor, context) {
    // editor.contents["main.asm"] = app.codeController?.text ?? "";
    final selectedIndex = DefaultTabController.of(context).index;
    final filename = editor.contents.keys.toList()[selectedIndex];
    editor.compile(filename);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Code is compiled, view the object code in its tab."),
        action: SnackBarAction(
          label: "View",
          onPressed: () {
            final objfile = editor.contents.keys
                .where((element) => element.endsWith(".vobj"))
                .toList()[0];
            final index = editor.contents.keys.toList().indexOf(objfile);
            DefaultTabController.of(context).animateTo(max(index, 0));
          },
        ),
      ),
    );
  }

  _onFormat(EditorWorkflow editor, context) {
    final index = DefaultTabController.of(context).index;
    final filename = editor.contents.keys.toList()[index];

    editor.format(filename);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 700) {
              return Row(
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => _onCompile(
                      editor,
                      context,
                    ),
                    label: Text("Build"),
                    icon: Icon(Icons.play_arrow_outlined),
                  ),
                  SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => editor.upload(emulator),
                    label: Text("Upload"),
                    icon: Icon(Icons.file_upload_outlined),
                  ),
                  SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => _onFormat(editor, context),
                    label: Text("Format"),
                    icon: Icon(Icons.format_align_left),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => _onCompile(
                      editor,
                      context,
                    ),
                    icon: Icon(
                      Icons.play_arrow_outlined,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () => editor.upload(emulator),
                    icon: Icon(
                      Icons.file_upload_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _onFormat(editor, context),
                    icon: Icon(
                      Icons.format_align_left,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              );
            }
          }),
        );
      });
    });
  }
}
