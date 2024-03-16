import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:sicxe/utils/sicxe/emulator/vm.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class SicxeEmulatorWorkflow extends EmulatorWorkflow {
  late SICXE vm;

  SicxeEmulatorWorkflow() {
    vm = SICXE(onOutput: _onOutput);
  }

  int get maxClockHz => 1500;

  _onOutput(int addr, int value) async {
    if (addr == 0x80) {
      super.termianl.write(String.fromCharCode(value));
    }
  }

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
      "instruction_bytes",
      "opcode_mnemonic",
      "regA",
      "regX",
      "regL",
      "regSw",
      "regB",
      "regS",
      "regT",
    ];
    final keyMapping = {
      "instruction_bytes": "instruction",
      "opcode_mnemonic": "opcode",
    };
    final originalMap = _toStringMap(vm.toMap());
    Map<String, String> resultMap = {};

    for (final key in whitelist) {
      resultMap[keyMapping[key] ?? key] = originalMap[key];
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
        "mnemonic": originalMap["opcode_mnemonic"] ?? "",
        "flags": originalMap["instruction_flags"] ?? "",
        "bytes": originalMap["instruction_bytes"] ?? "",
      },
      "Target Address": {
        // "mode": originalMap["ta_adressing_mode"] ?? "",
        "calculation": originalMap["operand_calc_disp"] ?? "",
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

  @override
  void onDeviceInput(int addr, int value) {
    // TODO: implement onDeviceInput
  }

  bool _isRunning = false;

  bool isLoopRunning() => _isRunning;

  stopEvalLoop() {
    _isRunning = false;
    notifyListeners();
  }

  Future<void> evalLoop(TimelineDataListsProvider tdlp) async {
    print("loop is starting...");
    _isRunning = true;
    notifyListeners();
    final counterStopwatch = Stopwatch();

    int counter = 0;
    counterStopwatch.start();

    while (_isRunning) {
      final clockPeriod = clockHz >= maxClockHz ? 0 : (1000000 ~/ clockHz);

      // debug output
      if (counterStopwatch.elapsedMicroseconds > 1000000) {
        print("counter: $counter, clockHz $clockHz");
        counterStopwatch.reset();

        counter = 0;
      }

      if (clockHz <= 100) {
        final vmFuture = vm.eval();
        final delayFuture = Future.delayed(Duration(
          microseconds: max(0, clockPeriod),
        ));

        await vmFuture;
        tdlp.add(toTimelineMap());
        notifyListeners();
        await delayFuture;

        counter++;
      } else {
        final timesInCycle = (clockHz * 0.05).floor();
        counter += timesInCycle;

        final futureDelay = Future.delayed(const Duration(
          milliseconds: 50,
        ));

        for (int i = 0; i < timesInCycle; i++) {
          await vm.eval();
          tdlp.add(toTimelineMap());
          notifyListeners();
        }

        await futureDelay;
      }
    }
  }
}
