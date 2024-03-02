import 'dart:typed_data';

import 'package:sicxe/utils/sicxe/emulator/vm.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class SicxeEmulatorWorkflow extends EmulatorWorkflow {
  SICXE vm = SICXE();

  @override
  Future<void> eval() async {
    await vm.eval();
    notifyListeners();
  }

  _toStringMap(Map<String, dynamic> map) {
    return map.map(
      (key, value) => MapEntry(
        key,
        value.toString(),
      ),
    );
  }

  @override
  Map<String, String> toTimelineMap() {
    final whitelist = [
      "pc",
      "regA",
      "regX",
      "regL",
      "regSw",
      "regB",
      "regS",
      "regT",
    ];
    final originalMap = _toStringMap(vm.toMap());
    Map<String, String> resultMap = {};

    for (final key in whitelist) {
      resultMap[key] = originalMap[key];
    }

    return resultMap;
  }

  @override
  Map<String, Map<String, String>> toInspectorMap() {
    final originalMap = _toStringMap(vm.toMap());
    return {
      "Program Counter": {
        "PC": originalMap['pc'] ?? "",
      },
      "Instruction": {
        "format": originalMap["instruction_format"] ?? "",
        "flags": originalMap["instruction_flags"] ?? "",
        "bytes": originalMap["instruction_bytes"] ?? "",
      },
      "TargetAddress": {
        "mode": originalMap["ta_adressing_mode"] ?? "",
        "operand": originalMap["instruction_operand"] ?? "",
        "fetched": "000000",
      },
      "Registers": {
        "regA": originalMap["regA"] ?? "",
        "regX": originalMap["regX"] ?? "",
        "regL": originalMap["regL"] ?? "",
        "regSw": originalMap["regSw"] ?? "",
        "regB": originalMap["regB"] ?? "",
        "regS": originalMap["regS"] ?? "",
        "regT": originalMap["regT"] ?? "",
      }
    };
  }

  @override
  Uint8List getMemory() {
    return vm.mem;
  }
}
