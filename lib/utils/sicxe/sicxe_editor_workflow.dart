import 'dart:convert';

import 'package:sicxe/pages/assembler_page/assembler_examples.dart';
import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/code_format.dart';
import 'package:sicxe/utils/sicxe/sicxe_emulator_workflow.dart';
import 'package:sicxe/utils/sicxe/assembler/simple_loader.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

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
    notifyListeners();
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
