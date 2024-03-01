import 'package:flutter/foundation.dart';

class TimelineScaleController extends ChangeNotifier {
  int _scale = 1;
  bool _smallView = false;

  TimelineScaleController();

  int get scale {
    return _scale;
  }

  set scale(int e) {
    _scale = e;

    _smallView = e == 2;

    notifyListeners();
  }

  bool get smallView {
    return _smallView;
  }

  double get totalHeight => fixedBottomPadding + fixedTopPadding + blockHeight;
  double get fixedBottomMargin => 8;
  double get fixedTopPadding => 36;
  double get fixedBottomPadding => 8;
  double get scrollLeftPadding => 16;
  double get blockHeight => 60;
  double get blockWidth => switch (_scale) {
        0 => 100,
        1 => 50,
        2 => 10,
        int() => 4,
      };
  double get afterPadding => switch (_scale) {
        0 => 3,
        1 => 3,
        2 => 1,
        int() => 0.2,
      };
}
