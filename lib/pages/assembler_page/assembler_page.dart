// Import the language & theme
import 'package:code_text_field/code_text_field.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sicxe/utils/assembler.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_editor_tab.dart';
import 'package:sicxe/pages/assembler_page/assembler_examples.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_object_program_tab/assembler_object_program_tab.dart';
import 'package:sicxe/widgets/overview_card.dart';

class AssemblerPage extends StatefulWidget {
  const AssemblerPage({super.key});

  @override
  State<AssemblerPage> createState() => _AssemblerPageState();
}

class _AssemblerPageState extends State<AssemblerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // title: Text("Assembler"),
            surfaceTintColor: Colors.transparent,
            title: TabBar(
              onTap: (value) {
                setState(() {});
              },
              tabs: [
                Tab(
                  // icon: Icon(Icons.auto_fix_high),
                  text: "Assembler Language",
                ),
                Tab(
                  // icon: Icon(Icons.view_in_ar_outlined),
                  text: "Object Program",
                ),
              ],
            ),
          ),
          // floatingActionButton: DefaultTabController.of(context).index == 0
          //     ?
          //     : null,
          // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: TabBarView(
            children: [
              AssemblerEditorTab(),
              AssemblerObjectProgramTab(),
            ],
          ),
        );
      }),
    );
  }
}
