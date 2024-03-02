import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/sicxe/sicxe_emulator_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/pages/playground_page/inspectors/vm_inspector.dart';
import 'package:sicxe/pages/playground_page/io_tab.dart';
import 'package:sicxe/pages/playground_page/logs_tab.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var fabLocation = FloatingActionButtonLocation.endFloat;

    return Consumer<DocumentDisplayProvider>(builder: (context, ddp, _) {
      return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
        final vm = (emulator as SicxeEmulatorWorkflow).vm;
        // fabLocation = FloatingActionButtonLocation.endFloat;
        // if (constraints.maxWidth < 700) {
        //   fabLocation = FloatingActionButtonLocation.centerFloat;
        // }

        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              // toolbarHeight: 100,
              title: TabBar(
                tabs: [
                  Tab(
                    // icon: Icon(Icons.menu_book_rounded),
                    text: "Registers",
                  ),
                  // Tab(
                  //   // icon: Icon(Icons.memory_rounded),
                  //   text: "Memory",
                  // ),
                  Tab(
                    // icon: Icon(Icons.view_list_outlined),
                    text: "Log",
                  ),
                  Tab(
                    // icon: Icon(Icons.developer_board_rounded),
                    text: "I/O",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                VMInspector(vm: vm),
                // SafeArea(
                //   minimum: const EdgeInsets.all(8.0),
                //   child: MemoryInspector(mem: vm.mem),
                // ),
                LogsTab(),
                IOTab(),
              ],
            ),
            // floatingActionButtonLocation: fabLocation,
            // floatingActionButton: ControlBarView(
            //   onStepThru: () async {
            //     await vm.eval();
            //     setState(() {});
            //   },
            //   onPlay: () async {},
            //   onSpeedup: () async {},
            // ),
          ),
        );
      });
    });
  }
}
