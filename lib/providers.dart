import 'package:flutter/material.dart';

// Providers
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/custom_colorscheme_provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/pages/assembler_page/assembler_page_provider.dart';
import 'package:sicxe/pages/terminal_page/terminal_controller.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar_controller.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/utils/sicxe/sicxe_editor_workflow.dart';
import 'package:sicxe/utils/sicxe/sicxe_emulator_workflow.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_controller.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/side_panel/side_panel_controller.dart';
import 'package:xterm/xterm.dart';

class Providers extends StatelessWidget {
  final Widget child;

  const Providers({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomColorshcemeProvider(
            Color.fromARGB(255, 246, 192, 58),
          ),
        ),
        ChangeNotifierProvider<DocumentDisplayProvider>(create: (_) {
          final ddm = DocumentDisplayProvider();
          ddm.changeMarkdown("README.md");
          return ddm;
        }),
        ChangeNotifierProvider<NavigationPageProvider>(
          create: (_) => NavigationPageProvider(),
        ),
        ChangeNotifierProvider<SidePanelController>(
          create: (_) => SidePanelController(),
        ),
        ChangeNotifierProvider<CustomPanelController>(
          create: (_) => CustomPanelController(),
        ),
        ChangeNotifierProvider<EmulatorWorkflow>(
          create: (_) => SicxeEmulatorWorkflow(),
        ),
        ChangeNotifierProvider<EditorWorkflow>(
          create: (_) => SicxeEditorWorkflow(),
        ),
        ChangeNotifierProvider<AssemblerPageProvider>(
          create: (_) => AssemblerPageProvider(
            colorScheme: colorScheme,
          ),
        ),
        ChangeNotifierProvider<TimingControlBarController>(
          create: (_) => TimingControlBarController(),
        ),
        Provider<LinkedScrollControllerGroup>(
          create: (_) => LinkedScrollControllerGroup(),
        ),
        ChangeNotifierProvider<TimelineScaleController>(
          create: (_) => TimelineScaleController(),
        ),
        ChangeNotifierProvider<TimelineDataListsProvider>(
          create: (_) => TimelineDataListsProvider(),
        ),
        // ChangeNotifierProvider<TerminalPageController>(
        //   create: (_) => TerminalPageController(),
        // ),
      ],
      child: child,
    );
  }
}
