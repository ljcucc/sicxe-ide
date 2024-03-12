import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_object_program_tab/object_code_visualize_provider.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_object_program_tab/object_program_record_widget.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/overview_card.dart';

class AssemblerObjectProgramTab extends StatefulWidget {
  final String filename;

  const AssemblerObjectProgramTab({
    super.key,
    required this.filename,
  });

  @override
  State<AssemblerObjectProgramTab> createState() =>
      _AssemblerObjectProgramTabState();
}

class _AssemblerObjectProgramTabState extends State<AssemblerObjectProgramTab> {
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
                            ObjectProgramRecordWdiget(
                                objectProgramRecord: record)
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
