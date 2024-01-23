import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/control_bar.dart';
import 'package:sicxe/playground_page/inspectors/memory_inspector.dart';
import 'package:sicxe/vm/vm.dart';
import 'package:sicxe/playground_page/inspectors/vm_inspector.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:sicxe/playground_page/logs_tab.dart';
import 'package:sicxe/playground_page/playground_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      final deviceColorScheme =
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? darkDynamic
              : lightDynamic;

      final defaultColorScheme = ColorScheme.fromSeed(
        seedColor: Color.fromARGB(0, 68, 255, 0),
        brightness: MediaQuery.of(context).platformBrightness,
      );

      return MaterialApp(
        title: 'SICXE VM',
        theme: ThemeData(
          colorScheme:
              Platform.isAndroid ? deviceColorScheme : defaultColorScheme,
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'SICXE VM'),
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

  @override
  Widget build(BuildContext context) {
    final compactLayout = MediaQuery.of(context).size.width < 800;
    final dispScreen = [
      Provider<SICXE>(
        create: (_) => vm,
        child: PlaygroundPage(),
      ),
      Text("Assembler"),
    ][_index];

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!compactLayout)
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (value) {
                setState(() {
                  _index = value;
                });
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.memory_rounded),
                  label: Text("Playground"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.auto_awesome_rounded),
                  label: Text("Assembler"),
                ),
              ],
              selectedIndex: _index,
            ),
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
                  icon: Icon(Icons.memory_rounded),
                  label: "Playground",
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
