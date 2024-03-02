import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/inspector_page/inspector_page.dart';
import 'package:sicxe/panels/assembler_symtab_widget.dart';
import 'package:sicxe/panels/memory_inspector.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_controller.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';

class CustomPanelWidget extends StatelessWidget {
  const CustomPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomPanelController>(
      builder: (context, controller, _) {
        return switch (controller.pageId) {
          "inspector" => const InspectorPage(
              padding: EdgeInsets.zero,
            ),
          "memory" => const MemoryInspector(),
          "symtab" => const AssemblerSymtabWidget(),
          String() => const DocumentDisplayWidget(),
        };
      },
    );
  }
}
