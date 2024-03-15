import 'package:flutter/material.dart';

class SidePanelController extends ChangeNotifier {
  bool _isOpen = false;
  double _width = 350;

  bool get isOpen => _isOpen;
  double get width => _width;

  set width(double size) {
    _width = size;
    notifyListeners();
  }

  void open() {
    _isOpen = true;
    notifyListeners();
  }

  void close() {
    _isOpen = false;
    notifyListeners();
  }

  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}
