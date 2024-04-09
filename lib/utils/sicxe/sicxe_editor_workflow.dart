import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sicxe/utils/sicxe/assembler_examples.dart';
import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/code_format.dart';
import 'package:sicxe/utils/sicxe/sicxe_emulator_workflow.dart';
import 'package:sicxe/utils/sicxe/loader/simple_loader.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:csv/csv.dart';

class SicxeEditorWorkflow extends EditorWorkflow {
  LlbAssembler? assembler;

  SicxeEditorWorkflow({
    required super.contents,
  });

  @override
  void compile(String filename) async {
    if (filename.trim().isEmpty) return;
    if (!filename.endsWith(".asm")) return;
    final name = filename.split(".").first;
    assembler = LlbAssembler(
      context: LlbAssemblerContext(
        text: await contents.getFileString(filename),
      ),
    );
    assembler?.pass1();
    assembler?.pass2();
    final objectCode =
        assembler?.context.records.map((e) => e.toMapList()).toList();
    contents.setFileString("$name.vobj", jsonEncode(objectCode));
    contents.setFileString(
      "symtab.csv",
      ListToCsvConverter().convert(
        _symtabToList(assembler?.context.symtab ?? {}),
      ),
    );
    notifyListeners();
  }

  List<List<String>> _symtabToList(Map<String, int> symtab) {
    final result = symtab.keys
        .map<List<String>>(
          (key) => [
            key,
            symtab[key]?.toRadixString(16) ?? "NaN",
          ],
        )
        .toList();
    result.insert(0, ["Symbol", "Loc"]);
    return result;
  }

  @override
  void upload(EmulatorWorkflow emulator) {
    final vm = (emulator as SicxeEmulatorWorkflow).vm;

    final loader = SimpleLoader(
      vm: vm,
      assembler: assembler!,
    );

    loader.load();

    emulator.notifyListeners();
  }

  @override
  void format(String filename) async {
    if (!filename.endsWith(".asm")) return;

    print("formating...");

    contents.setFileString(
      filename,
      codeFormat(await contents.getFileString(filename)),
    );
    notifyListeners();

    print("done!");
  }

  @override
  Future<void> createTemplate() async {
    await contents.newFile("main.asm", assemblerExampleCode);
    await contents.newFile("output.asm", terminalExample);
    await contents.newFile("README.md", """# SIC/XE
A hypothetical virtual machine design by Leland L. Beck in his book: System Software: An Introduction to System Programming

Template project contains some example code:

* main.asm: an example inspired from the page 47 in book.
* output.asm: terminal output example.

""");
// ${kIsWeb ? "currently the web version will using IndexedDB as storage, remove the IndexedDB will reset the app." : ""}
  }
}
