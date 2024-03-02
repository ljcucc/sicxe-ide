import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/compact_layout.dart';
import 'package:sicxe/large_layout.dart';

// Providers
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:sicxe/custom_colorscheme_provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/pages/assembler_page/assembler_page_provider.dart';
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

import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
}

class Providers extends StatelessWidget {
  final Widget child;

  const Providers({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MultiProvider(
      providers: [
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
        Provider<Terminal>(
          create: (_) => Terminal(
            onOutput: (data) {
              print(data);
            },
          ),
        ),
      ],
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomColorshcemeProvider(
        Color.fromARGB(255, 246, 192, 58),
      ),
      child: Consumer<CustomColorshcemeProvider>(
        builder: (context, colorschemeProvider, _) {
          var defaultColorScheme = ColorScheme.fromSeed(
            seedColor: colorschemeProvider.color,
            brightness: MediaQuery.of(context).platformBrightness,
          );

          if (kIsWeb) {
            return MaterialApp(
              title: 'SICXE VM',
              theme: ThemeData(
                colorScheme: defaultColorScheme,
                useMaterial3: true,
                brightness: MediaQuery.of(context).platformBrightness,
              ),
              home: Providers(child: MyHomePage(title: 'SICXE')),
              debugShowCheckedModeBanner: false,
            );
          }

          return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
            final deviceColorScheme =
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? darkDynamic
                    : lightDynamic;

            return MaterialApp(
              title: 'SICXE VM',
              theme: ThemeData(
                colorScheme:
                    Platform.isAndroid ? deviceColorScheme : defaultColorScheme,
                useMaterial3: true,
              ),
              home: Providers(
                child: MyHomePage(title: 'SICXE'),
              ),
              debugShowCheckedModeBanner: false,
            );
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final compactLayout =
        MediaQuery.of(context).orientation == Orientation.portrait &&
            MediaQuery.of(context).size.width < 700;

    Widget body = (compactLayout) ? CompactLayout() : LargeLayout();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            stops: const [0.6, 1],
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}
