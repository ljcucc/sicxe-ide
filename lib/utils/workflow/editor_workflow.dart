import 'package:flutter/material.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

abstract class EditorWorkflow extends ChangeNotifier {
  /// compile codes from editor and store it in object
  void compile(Map<String, String> contents);

  /// upload compiled code to emulator
  void upload(EmulatorWorkflow emulator);
}
