import 'dart:convert';

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

  SicxeEditorWorkflow() {
    contents = {
      "main.asm": assemblerExampleCode,
      "output.asm": terminalExample,
    };
  }

  @override
  void compile(String filename) {
    final name = filename.split(".").first;
    assembler = LlbAssembler(
      context: LlbAssemblerContext(
        text: contents[filename] ?? "",
      ),
    );
    assembler?.pass1();
    assembler?.pass2();
    final objectCode =
        assembler?.context.records.map((e) => e.toMapList()).toList();
    contents["$name.vobj"] = jsonEncode(objectCode);
    contents["symtab.csv"] = ListToCsvConverter().convert(
      _symtabToList(assembler?.context.symtab ?? {}),
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
  void format(String filename) {
    if (!filename.endsWith(".asm")) return;

    contents[filename] = codeFormat(contents[filename] ?? "");
    print(contents[filename]);
    notifyListeners();
  }
}
