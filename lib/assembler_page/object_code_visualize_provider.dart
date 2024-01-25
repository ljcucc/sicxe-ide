import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObjectCodeIsVisualized extends ChangeNotifier {
  bool _visualized = false;

  bool get visualized => _visualized;

  set visualized(bool value) {
    _visualized = value;
    notifyListeners();
  }
}
