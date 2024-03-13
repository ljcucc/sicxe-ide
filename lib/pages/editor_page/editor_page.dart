// Import the language & theme
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/editor_buttons.dart';
import 'package:sicxe/pages/editor_page/tabs/text_editor_tab.dart';
import 'package:sicxe/pages/editor_page/tabs/vobj_viewer_tab/vobj_viewer_tab.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  @override
  void initState() {
    super.initState();
  }

  _closeTab(index) {
    final editor = Provider.of<EditorWorkflow>(context, listen: false);
    final filename = editor.contents.keys.toList()[index];
    editor.contents.remove(filename);
    setState(() {});
  }

  _newFile() async {
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
    if (filename.isEmpty) return;

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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
      return Consumer<EditorWorkflow>(builder: (context, editor, _) {
        return DefaultTabController(
          animationDuration: Duration.zero,
          initialIndex: 0,
          length: editor.contents.keys.length,
          child: Builder(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                // title: Text("Assembler"),
                surfaceTintColor: Colors.transparent,
                centerTitle: false,
                title: EditorButtons(),
              ),
              // floatingActionButton: DefaultTabController.of(context).index == 0
              //     ?
              //     : null,
              // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: TabBar.secondary(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            onTap: (value) {
                              setState(() {});
                            },
                            tabs: [
                              for (var filename in editor.contents.keys)
                                Tab(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        switch (filename.split(".").last) {
                                          "asm" => Icons.code,
                                          "vobj" => Icons.view_in_ar_outlined,
                                          String() =>
                                            Icons.insert_drive_file_outlined,
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      Text(filename),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        PopupMenuButton(
                          itemBuilder: (_) => <PopupMenuEntry>[
                            PopupMenuItem(
                              onTap: () async => await _newFile(),
                              child: ListTile(
                                leading: Icon(Icons.add),
                                title: Text("New tab"),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () => _closeTab(
                                DefaultTabController.of(context).index,
                              ),
                              child: ListTile(
                                leading: Icon(Icons.close),
                                title: Text("Close tab"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SafeArea(
                      minimum: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 20),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.05),
                              spreadRadius: 0,
                              blurRadius: 15,
                            )
                          ],
                        ),
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            for (var filename in editor.contents.keys) ...[
                              if (filename.endsWith(".asm"))
                                TextEditorTab(
                                  filename: filename,
                                  text: editor.contents[filename] ?? "",
                                  onChange: (e) {
                                    editor.contents[filename] = e;
                                  },
                                ),
                              if (filename.endsWith(".vobj"))
                                VobjViewerTab(filename: filename ?? ""),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      });
    });
  }
}
