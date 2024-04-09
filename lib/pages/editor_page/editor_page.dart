// Import the language & theme
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/editor_tab_bar.dart';
import 'package:sicxe/pages/editor_page/editor_tab_controller.dart';
import 'package:sicxe/pages/editor_page/editor_tab_view.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  int tabLength = 0;

  @override
  void initState() {
    super.initState();

    _loadTabLength();
  }

  _loadTabLength() async {
    final editor = Provider.of<EditorWorkflow>(context, listen: false);
    tabLength = (await editor.contents.getFileList()).length;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
      return Consumer<EditorWorkflow>(builder: (context, editor, _) {
        return DefaultTabController(
          animationDuration: Duration.zero,
          initialIndex: 0,
          length: tabLength,
          child: Builder(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EditorTabBar(),
                ),
                Expanded(
                  child: SafeArea(
                    minimum: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
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
                      child: Consumer<EditorTabController>(
                          builder: (context, etc, _) {
                        return EditorTabView(
                          key: Key("${etc.tabId}${etc.changed}"),
                          tabId: etc.tabId,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      });
    });
  }
}
