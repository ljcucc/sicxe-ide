// Import the language & theme
import 'package:code_text_field/code_text_field.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sicxe/pages/assembler_page/assembler.dart';
import 'package:sicxe/pages/assembler_page/assembler_editor_tab.dart';
import 'package:sicxe/pages/assembler_page/assembler_examples.dart';
import 'package:sicxe/pages/assembler_page/assembler_object_program_tab.dart';
import 'package:sicxe/widgets/overview_card.dart';

class AssemblerPage extends StatefulWidget {
  const AssemblerPage({super.key});

  @override
  State<AssemblerPage> createState() => _AssemblerPageState();
}

class _AssemblerPageState extends State<AssemblerPage> {
  CodeController? _codeController;
  LlbAssembler? _assembler;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");

    // Instantiate the CodeController
    final primary = Theme.of(context).colorScheme.primary;
    final tertiary = Theme.of(context).colorScheme.tertiary;
    _codeController = CodeController(text: assemblerExampleCode, stringMap: {
      'WORD': TextStyle(color: primary),
      'BYTE': TextStyle(color: primary),
      'RESW': TextStyle(color: primary),
      'RESB': TextStyle(color: primary),
      'START': TextStyle(color: primary),
      'END': TextStyle(color: primary),
    }, patternMap: {
      r"\..*": TextStyle(color: tertiary.withOpacity(.5)),
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Assembler"),
            surfaceTintColor: Colors.transparent,
            bottom: TabBar(
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
          floatingActionButton: DefaultTabController.of(context).index == 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    _assembler =
                        LlbAssembler(text: _codeController?.text ?? "");
                    _assembler?.pass1();
                    _assembler?.pass2();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                            "Code is compiled, view the object code in its tab."),
                        action: SnackBarAction(
                          label: "View",
                          onPressed: () =>
                              DefaultTabController.of(context).animateTo(1),
                        ),
                      ),
                    );
                  },
                  label: Text("Compile"),
                  icon: Icon(Icons.memory_rounded),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: TabBarView(
            children: [
              AssemblerEditorTab(
                assembler: _assembler,
                codeController: _codeController,
              ),
              AssemblerObjectProgramTab(assembler: _assembler),
            ],
          ),
        );
      }),
    );
  }
}
