import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/editor_tab_controller.dart';
import 'package:sicxe/pages/editor_page/tabs/csv_viewer_tab.dart';
import 'package:sicxe/pages/editor_page/tabs/text_editor_tab.dart';
import 'package:sicxe/pages/editor_page/tabs/vobj_viewer_tab/vobj_viewer_tab.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class EditorTabView extends StatefulWidget {
  final String tabId;
  const EditorTabView({
    super.key,
    required this.tabId,
  });

  @override
  State<EditorTabView> createState() => _EditorTabViewState();
}

class _EditorTabViewState extends State<EditorTabView> {
  late Future<String> sourceString;
  String tabId = "";

  @override
  void initState() {
    _loadTabFile();
    super.initState();
  }

  _loadTabFile() {
    final editor = Provider.of<EditorWorkflow>(context, listen: false);

    sourceString =
        editor.contents.getFileString(widget.tabId, fallbackString: "");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      if (widget.tabId.isEmpty) {
        return Center(
          child: Text("Open a file from Assets to continue"),
        );
      }
      return FutureBuilder(
          future: sourceString,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container();
            }
            final stringSource = snapshot.data ?? "";

            if (widget.tabId.endsWith(".asm")) {
              return TextEditorTab(
                key: Key(widget.tabId),
                filename: widget.tabId,
                text: stringSource,
                onChange: (e) {
                  editor.contents.setFileString(widget.tabId, e);
                },
              );
            }
            if (widget.tabId.endsWith(".vobj")) {
              return VobjViewerTab(sourceString: stringSource);
            }
            if (widget.tabId.endsWith(".csv")) {
              return CsvViewerTab(sourceString: stringSource);
            }
            return Center(
              child: Text("This file is not editable"),
            );
          });
    });
  }
}
