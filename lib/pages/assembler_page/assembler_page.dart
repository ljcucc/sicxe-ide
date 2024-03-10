// Import the language & theme
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_editor_tab.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_object_program_tab/assembler_object_program_tab.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class AssemblerPage extends StatefulWidget {
  const AssemblerPage({super.key});

  @override
  State<AssemblerPage> createState() => _AssemblerPageState();
}

class _AssemblerPageState extends State<AssemblerPage> {
  @override
  void initState() {
    super.initState();
  }

  _onCompile(EditorWorkflow editor, context) {
    // editor.contents["main.asm"] = app.codeController?.text ?? "";
    editor.compile();

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

  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
      return Consumer<EditorWorkflow>(builder: (context, editor, _) {
        print(editor.contents.keys);
        return DefaultTabController(
          initialIndex: 0,
          length: editor.contents.keys.length,
          child: Builder(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                // title: Text("Assembler"),
                surfaceTintColor: Colors.transparent,
                centerTitle: false,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    if (constraints.maxWidth > 700) {
                      return Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () => _onCompile(
                              editor,
                              context,
                            ),
                            label: Text("Compile"),
                            icon: Icon(Icons.play_arrow_outlined),
                          ),
                          SizedBox(width: 16),
                          FilledButton.tonalIcon(
                            onPressed: () => editor.upload(emulator),
                            label: Text("Upload"),
                            icon: Icon(Icons.file_upload_outlined),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          IconButton.filled(
                            onPressed: () => _onCompile(
                              editor,
                              context,
                            ),
                            icon: Icon(
                              Icons.play_arrow_outlined,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton.filledTonal(
                            onPressed: () => editor.upload(emulator),
                            icon: Icon(Icons.file_upload_outlined),
                          ),
                        ],
                      );
                    }
                  }),
                ),
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
                                  text: filename,
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        for (var filename in editor.contents.keys) ...[
                          if (filename.endsWith(".asm"))
                            AssemblerEditorTab(
                              filename: filename,
                              text: editor.contents[filename] ?? "",
                              onChange: (e) {},
                            ),
                          if (filename.endsWith(".vobj"))
                            AssemblerObjectProgramTab(filename: filename ?? ""),
                        ],
                      ],
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
