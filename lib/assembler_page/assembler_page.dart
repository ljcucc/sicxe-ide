// Import the language & theme
import 'package:code_text_field/code_text_field.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sicxe/assembler_page/assembler.dart';
import 'package:sicxe/assembler_page/assembler_editor_tab.dart';
import 'package:sicxe/assembler_page/assembler_object_program_tab.dart';
import 'package:sicxe/overview_card.dart';

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

    final source = """COPY   START  1000
FIRST  STL    RETADR
CLOOP  JSUB   RDREC
       LDA    LENGTH
       COMP   ZERO
       JEQ    ENDFIL
       JSUB   WRREC
       J      CLOOP
ENDFIL LDA    EOF
       STA    BUFFER
       LDA    THREE
       STA    LENGTH
       JSUB   WRREC
       LDL    RETADR
       RSUB
EOF    BYTE   C'EOF'
THREE  WORD   3
ZERO   WORD   0
RETADR RESW   1
LENGTH RESW   1
BUFFER RESB   4096
.
.      SUBROUTINE TO READ RECORD INTO BUFFER
.
RDREC  LDX    ZERO
       LDA    ZERO
RLOOP  TD     INPUT
       JEQ    RLOOP
       RD     INPUT
       COMP   ZERO
       JEQ    EXIT
       STCH   BUFFER,X
       TIX    MAXLEN
       JLT    RLOOP
EXIT   STX    LENGTH
       RSUB
INPUT  BYTE   X'F1'
MAXLEN WORD   4096
.
.      SUBROUTINE TO WRITE RECORD FROM BUFFER
.
WRREC  LDX    ZERO
WLOOP  TD     OUTPUT
       JEQ    WLOOP
       LDCH   BUFFER,X
       WD     OUTPUT
       TIX    LENGTH
       JLT    WLOOP
       RSUB
OUTPUT BYTE   X'06'
       END    FIRST
""";
    // Instantiate the CodeController
    final primary = Theme.of(context).colorScheme.primary;
    final tertiary = Theme.of(context).colorScheme.tertiary;
    _codeController = CodeController(text: source, stringMap: {
      'WORD': TextStyle(color: primary),
      'BYTE': TextStyle(color: primary),
      'RESW': TextStyle(color: primary),
      'RESB': TextStyle(color: primary),
      'START': TextStyle(color: primary),
      'END': TextStyle(color: primary),
    }, patternMap: {
      r"\..*": TextStyle(color: tertiary),
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
                Tab(text: "Assembler Language"),
                Tab(text: "Object Program"),
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
