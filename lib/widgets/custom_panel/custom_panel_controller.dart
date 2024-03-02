import 'package:flutter/material.dart';

class CustomPanelController extends ChangeNotifier {
  String _pageId = "";

  String get pageId => _pageId;

  set pageId(String pageId) {
    _pageId = pageId;
    notifyListeners();
  }
}
