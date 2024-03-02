import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class EmulatorWorkflow extends ChangeNotifier {
  /// run emulator a step each time.
  Future<void> eval();

  /// this toMap function will only return the map that will showing on timeline
  Map<String, String> toTimelineMap();

  /// this toMap function will return all stages data from decode, fetching to execution.
  Map<String, Map<String, String>> toInspectorMap();

  Uint8List getMemory();
}
