import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/sicxe_emulator_workflow.dart';
import 'package:sicxe/utils/sicxe/assembler/simple_loader.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class SicxeEditorWorkflow extends EditorWorkflow {
  LlbAssembler? assembler;

  @override
  void compile(Map<String, String> contents) {
    assembler = LlbAssembler(text: contents["main"] ?? "");
    assembler?.pass1();
    assembler?.pass2();

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
}
