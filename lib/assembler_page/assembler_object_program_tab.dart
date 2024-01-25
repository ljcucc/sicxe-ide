import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/assembler_page/assembler.dart';
import 'package:sicxe/assembler_page/object_code_visualize_provider.dart';
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
        expanded: true,
        child: ChangeNotifierProvider<ObjectCodeIsVisualized>(
          create: (_) => visualized,
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
                          Padding(
                            padding: EdgeInsets.only(bottom: 32),
                            child: FilledButton.tonal(
                              onPressed: () {
                                visualized.visualized = !visualized.visualized;
                              },
                              child: Text("Toggle visualization"),
                            ),
                          ),
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
      ),
    );
  }
}
