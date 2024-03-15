import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sicxe/pages/timeline_page/timline_data_lists_provider.dart';
import 'package:xterm/xterm.dart';

typedef TimelineMap = Map<String, String>;
typedef InspectorMap = Map<String, Map<String, String>>;

class EmulatorSnapshot {
  final TimelineMap timelineMap;
  final InspectorMap insepctorMap;
  const EmulatorSnapshot({
    required this.insepctorMap,
    required this.timelineMap,
  });
}

abstract class EmulatorWorkflow extends ChangeNotifier {
  int _clockHz = 1;

  /// Get the running clock hz of emulator
  int get clockHz => _clockHz;

  /// Set the running clock hz of emulator
  set clockHz(int hz) {
    _clockHz = hz;
    notifyListeners();
  }

  Terminal termianl = Terminal();

  /// run emulator a step each time.
  Future<void> eval();

  /// this toMap function will only return the map that will showing on timeline
  TimelineMap toTimelineMap();

  /// this toMap function will return all stages data from decode, fetching to execution.
  InspectorMap toInspectorMap();

  /// get in-emulator memory in type uint8list
  Uint8List getMemory();

  void onDeviceInput(int addr, int value);

  bool isLoopRunning();

  stopEvalLoop();

  Future<void> evalLoop(TimelineDataListsProvider tdlp);
}
