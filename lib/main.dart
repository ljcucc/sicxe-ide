import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/assembler_page.dart';
import 'package:sicxe/widgets/document_display/document_display_model.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';
import 'package:sicxe/pages/home_page/home_page.dart';
import 'package:sicxe/utils/vm/vm.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:sicxe/pages/playground_page/playground_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 0, 255, 255),
      brightness: MediaQuery.of(context).platformBrightness,
    );

    if (kIsWeb) {
      return MaterialApp(
        title: 'SICXE VM',
        theme: ThemeData(
          colorScheme: defaultColorScheme,
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'SICXE VM'),
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
        home: const DocumentDisplayProvider(
          child: MyHomePage(title: 'SICXE VM'),
        ),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SICXE vm = SICXE();
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
      "assembly_language.md"
    ];

    Provider.of<DocumentDisplayModel>(context, listen: false).changeMarkdown(
      documentFilenames[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    final compactLayout =
        MediaQuery.of(context).orientation == Orientation.portrait ||
            MediaQuery.of(context).size.height < 500;
    final dispScreen = [
      HomePage(),
      Provider<SICXE>(
        create: (_) => vm,
        child: PlaygroundPage(),
      ),
      AssemblerPage(),
    ][_index];

    if (compactLayout) {
      return Container(
        child: Center(
          child: Text("compact layout is not support now"),
        ),
      );
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            groupAlignment: 0,
            onDestinationSelected: (value) {
              _setPage(value);
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Home"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.memory_rounded),
                label: Text("Emulator"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.auto_awesome_rounded),
                label: Text("Assembler"),
              ),
            ],
            selectedIndex: _index,
          ),
          SizedBox(width: 350, child: DocumentDisplayWidget()),
          Expanded(child: dispScreen),
        ],
      ),
      bottomNavigationBar: compactLayout
          ? NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) {
                setState(() {
                  _index = value;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.memory_rounded),
                  label: "Emulator",
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_awesome_rounded),
                  label: "Assembler",
                ),
              ],
            )
          : null,
    );
  }
}
