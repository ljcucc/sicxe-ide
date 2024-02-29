import 'dart:ui';

import 'package:flutter/foundation.dart';

class CustomColorshcemeProvider extends ChangeNotifier {
  late Color _color;

  CustomColorshcemeProvider(Color color) {
    _color = color;
  }

  set color(Color color) {
    _color = color;
    notifyListeners();
  }

  Color get color {
    return _color;
  }
}
