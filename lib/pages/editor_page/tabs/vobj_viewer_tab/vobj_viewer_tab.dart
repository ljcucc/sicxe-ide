import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/tabs/vobj_viewer_tab/object_code_visualize_provider.dart';
import 'package:sicxe/pages/editor_page/tabs/vobj_viewer_tab/vobj_block_widget.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class VobjViewerTab extends StatefulWidget {
  final String filename;

  const VobjViewerTab({
    super.key,
    required this.filename,
  });

  @override
  State<VobjViewerTab> createState() => _VobjViewerTabState();
}

class _VobjViewerTabState extends State<VobjViewerTab> {
  ObjectCodeIsVisualized visualized = ObjectCodeIsVisualized();

  _objectCodeToString(List<List<Map<String, String>>> objectCode) {
    return objectCode.map((e) => e.map((e) => e['text'] ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      final jsonSource = editor.contents[widget.filename] ?? "[]";
      List<List<Map<String, String>>> objectCodes =
          (jsonDecode(jsonSource) as List).map((e) {
        return (e as List).map<Map<String, String>>((originalMap) {
          Map<String, String> result = {};
          for (final key in originalMap.keys) {
            result[key] = originalMap[key] as String;
          }
          return result;
        }).toList();
      }).toList();

      return SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: ChangeNotifierProvider<ObjectCodeIsVisualized>(
          create: (_) => visualized,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final record in objectCodes)
                            VobjBlockWdiget(objectProgramRecord: record)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, left: 4),
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.visibility_outlined),
                        title: Text("Toggle blockly view"),
                      ),
                      onTap: () {
                        visualized.visualized = !visualized.visualized;
                      },
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text("Copy to clipboard"),
                        leading: Icon(Icons.copy_rounded),
                      ),
                      onTap: () {
                        final texts = _objectCodeToString(objectCodes);
                        Clipboard.setData(ClipboardData(text: texts));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text("Object program copied to clipboard"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
