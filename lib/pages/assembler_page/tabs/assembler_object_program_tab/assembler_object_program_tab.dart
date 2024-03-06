import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_object_program_tab/object_code_visualize_provider.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_object_program_tab/object_program_record_widget.dart';
import 'package:sicxe/utils/sicxe/assembler/object_program_record.dart';
import 'package:sicxe/utils/sicxe/sicxe_editor_workflow.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/overview_card.dart';

class AssemblerObjectProgramTab extends StatefulWidget {
  const AssemblerObjectProgramTab({super.key});

  @override
  State<AssemblerObjectProgramTab> createState() =>
      _AssemblerObjectProgramTabState();
}

class _AssemblerObjectProgramTabState extends State<AssemblerObjectProgramTab> {
  ObjectCodeIsVisualized visualized = ObjectCodeIsVisualized();

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      final assembler = (editor as SicxeEditorWorkflow).assembler;

      return SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: OverviewCard(
          title: const Text("Object program"),
          onInfoOpen: () =>
              Provider.of<DocumentDisplayProvider>(context, listen: false)
                  .changeMarkdown("object_program.md"),
          expanded: true,
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
                            for (ObjectProgramRecord record
                                in assembler?.records ?? [])
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
                          final texts = assembler?.records
                                  .map((e) => e.getRecord())
                                  .join() ??
                              "";
                          Clipboard.setData(ClipboardData(text: texts));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content:
                                  Text("Object program copied to clipboard"),
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          title: Text("Upload to memory"),
                          leading: Icon(Icons.file_upload_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
