import 'package:flutter/foundation.dart';

class TimingControlBarController extends ChangeNotifier {
  bool _enable = false;

  bool get enable {
    return _enable;
  }

  set enable(bool e) {
    _enable = e;
    notifyListeners();
  }
}
