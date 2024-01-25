import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/assembler_page/assembler.dart';
import 'package:sicxe/assembler_page/object_code_visualize_provider.dart';
import 'package:sicxe/description_dialog.dart';
import 'package:sicxe/documents.dart';
import 'package:sicxe/overview_card.dart';

class AssemblerObjectProgramTab extends StatefulWidget {
  final LlbAssembler? assembler;

  const AssemblerObjectProgramTab({super.key, required this.assembler});

  @override
  State<AssemblerObjectProgramTab> createState() =>
      _AssemblerObjectProgramTabState();
}

class _AssemblerObjectProgramTabState extends State<AssemblerObjectProgramTab> {
  ObjectCodeIsVisualized visualized = ObjectCodeIsVisualized();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(16),
      child: OverviewCard(
        title: const Text("Object program"),
        description: FutureBuilder(
          future: getDocument("object_program.md"),
          builder: (context, snapshot) {
            return DescriptionDialog(
              title: "Object program 和 Records",
              markdown: snapshot.data ?? "",
            );
          },
        ),
        expanded: true,
        child: ChangeNotifierProvider<ObjectCodeIsVisualized>(
          create: (_) => visualized,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    child: Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (ObjectProgramRecord record
                                    in widget.assembler?.records ?? [])
                                  record.getInteractiveDisp(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, left: 4),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      icon: Icon(Icons.visibility_outlined),
                      onPressed: () {
                        visualized.visualized = !visualized.visualized;
                      },
                      label: Text("Toggle visualization"),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        final texts = widget.assembler?.records
                                .map((e) => e.getRecord())
                                .join() ??
                            "";
                        Clipboard.setData(ClipboardData(text: texts));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text("Object program copied to clipboard"),
                          ),
                        );
                      },
                      icon: Icon(Icons.copy_rounded),
                      label: Text("Copy to clipboard"),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () {},
                      icon: Icon(Icons.file_download_outlined),
                      label: Text("Directly import to RAM"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
