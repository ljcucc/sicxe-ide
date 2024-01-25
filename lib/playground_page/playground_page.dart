import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/control_bar.dart';
import 'package:sicxe/playground_page/inspectors/memory_inspector.dart';
import 'package:sicxe/playground_page/inspectors/vm_inspector.dart';
import 'package:sicxe/playground_page/io_tab.dart';
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
    if (size.width < size.height && size.height < 900) {
      fabLocation = FloatingActionButtonLocation.centerFloat;
    }

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Emulator"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.menu_book_rounded),
                text: "Overview",
              ),
              Tab(
                icon: Icon(Icons.memory_rounded),
                text: "Memory",
              ),
              Tab(
                icon: Icon(Icons.view_list_outlined),
                text: "Log",
              ),
              Tab(
                icon: Icon(Icons.developer_board_rounded),
                text: "I/O",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VMInspector(vm: vm),
            SafeArea(
              minimum: const EdgeInsets.all(8.0),
              child: MemoryInspector(mem: vm.mem),
            ),
            LogsTab(),
            IOTab(),
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
