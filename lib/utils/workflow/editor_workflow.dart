import 'package:flutter/material.dart';
import 'package:sicxe/pages/assembler_page/assembler_examples.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

abstract class EditorWorkflow extends ChangeNotifier {
  Map<String, String> contents = {};

  /// compile codes from editor and store it in object
  void compile(String filename);

  /// upload compiled code to emulator
  void upload(EmulatorWorkflow emulator);

  void format(String filename);
}
