import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/editor_tab_controller.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class EditorTabMenu extends StatelessWidget {
  const EditorTabMenu({super.key});

  _closeTab(context) {
    final editor = Provider.of<EditorWorkflow>(context, listen: false);
    final etc = Provider.of<EditorTabController>(context, listen: false);
    final filename =
        Provider.of<EditorTabController>(context, listen: false).tabId;

    etc.closeTab(filename);
    editor.contents.remove(filename);
  }

  _newFile(context) async {
    print("_newFile");
    String filename = "";
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController filenameInput = TextEditingController.fromValue(
          const TextEditingValue(text: "helluwu.asm"),
        );
        return AlertDialog(
          title: Text("New Tab"),
          content: TextField(
            controller: filenameInput,
          ),
          actions: [
            FilledButton(
              onPressed: () {
                print(filenameInput.text);
                filename = filenameInput.text;
                if (!filename.endsWith(".asm")) {
                  filename += ".asm";
                }

                Navigator.of(context).pop();
              },
              child: Text("Create"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );

    print("filename: $filename");
    if (filename.trim().isEmpty) return;

    final editor = Provider.of<EditorWorkflow>(context, listen: false);
    if (editor.contents.containsKey(filename)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("The tab name is exists."),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: () {},
          ),
        ),
      );
      return;
    }

    editor.contents[filename] = ". enter your code here";

    final etc = Provider.of<EditorTabController>(context, listen: false);
    etc.openTab(filename);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.arrow_drop_down_rounded),
      itemBuilder: (_) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () async => await _newFile(context),
          child: const ListTile(
            leading: Icon(Icons.add),
            title: Text("New tab"),
          ),
        ),
        PopupMenuItem(
          onTap: () => _closeTab(context),
          child: const ListTile(
            leading: Icon(Icons.close),
            title: Text("Close tab"),
          ),
        ),
      ],
    );
  }
}
