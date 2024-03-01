import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/compact_layout.dart';
import 'package:sicxe/custom_colorscheme_provider.dart';
import 'package:sicxe/large_layout.dart';
import 'package:sicxe/pages/assembler_page/assembler_page_provider.dart';
import 'package:sicxe/pages/playground_page/sicxe_vm_provider.dart';
import 'package:sicxe/pages/timeline_page/timeline_scale_controller.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar_controller.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';

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
        ChangeNotifierProvider(create: (_) {
          final ddm = DocumentDisplayProvider();
          ddm.changeMarkdown("README.md");
          return ddm;
        }),
        ChangeNotifierProvider<SicxeVmProvider>(
          create: (_) => SicxeVmProvider(),
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
        )
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
              home: Providers(child: MyHomePage(title: 'SICXE')),
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
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  _setPage(index) {
    setState(() {
      _index = index;
    });

    final documentFilenames = [
      "README.md",
      "emulator.md",
      "emulator.md",
      "assembler_language.md"
    ];

    Provider.of<DocumentDisplayProvider>(context, listen: false).changeMarkdown(
      documentFilenames[min(documentFilenames.length - 1, index)],
    );

    Provider.of<TimingControlBarController>(context, listen: false).enable =
        index == 1 || index == 2;
  }

  @override
  Widget build(BuildContext context) {
    final compactLayout =
        MediaQuery.of(context).orientation == Orientation.portrait &&
            MediaQuery.of(context).size.width < 700;

    Widget body = (compactLayout)
        ? CompactLayout(
            selectedIndex: _index,
            onSelected: _setPage,
          )
        : LargeLayout(
            selectedIndex: _index,
            onSelected: (index) => _setPage(index),
          );

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
