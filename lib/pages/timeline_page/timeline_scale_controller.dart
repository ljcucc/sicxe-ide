import 'package:flutter/foundation.dart';

class TimelineScaleController extends ChangeNotifier {
  int _scale = 1;
  bool _instructionCycle = false;
  bool _smallView = false;

  TimelineScaleController() {}

  int get scale {
    return _scale;
  }

  set scale(int e) {
    _scale = e;

    _instructionCycle = e == 0;
    _smallView = e == 2;

    notifyListeners();
  }

  bool get instructionCycle {
    return _instructionCycle;
  }

  bool get smallView {
    return _smallView;
  }
}
