import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/control_bar.dart';
import 'package:sicxe/playground_page/inspectors/memory_inspector.dart';
import 'package:sicxe/playground_page/inspectors/vm_inspector.dart';
import 'package:sicxe/vm/vm.dart';
import 'package:sicxe/playground_page/logs_tab.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  late SICXE vm;

  @override
  void initState() {
    super.initState();

    vm = context.read<SICXE>();
  }

  @override
  Widget build(BuildContext context) {
    var fabLocation = FloatingActionButtonLocation.endFloat;

    final size = MediaQuery.of(context).size;
    if (size.width < size.height) {
      fabLocation = FloatingActionButtonLocation.centerFloat;
    }

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text("SICXE VM"),
          bottom: TabBar(tabs: [
            Tab(
              text: "Overview",
            ),
            Tab(
              text: "Log",
            ),
            Tab(
              text: "Memory",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            VMInspector(vm: vm),
            LogsTab(),
            SafeArea(
              minimum: const EdgeInsets.all(8.0),
              child: MemoryInspector(mem: vm.mem),
            ),
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
