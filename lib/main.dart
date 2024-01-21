import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sicxe/control_bar.dart';
import 'package:sicxe/vm/vm.dart';
import 'package:sicxe/inspectors/vm_inspector.dart';

import 'package:dynamic_color/dynamic_color.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fabLocation = FloatingActionButtonLocation.endFloat;

    final size = MediaQuery.of(context).size;
    if (size.width < size.height) {
      fabLocation = FloatingActionButtonLocation.centerFloat;
    }

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(tabs: [
            Tab(
              text: "Overview",
            ),
            Tab(
              text: "Assembler",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            VMInspector(vm: vm),
            Text("Assembler"),
          ],
        ),
        floatingActionButtonLocation: fabLocation,
        floatingActionButton: ControlBarView(
          onStepThru: () async {
            await vm.eval();
            setState(() {});
          },
          onPlay: () async {},
          onSpeedup: () async {},
        ),
      ),
    );
  }
}
