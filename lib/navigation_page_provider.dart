import 'package:flutter/material.dart';

enum NavigationPageId {
  Home,
  Timeline,
  Inspector,
  Terminal,
  Assembler,
}

class NavigationPageProvider extends ChangeNotifier {
  NavigationPageId _pageId = NavigationPageId.Home;

  NavigationPageId get id {
    return _pageId;
  }

  set id(NavigationPageId id) {
    _pageId = id;
    notifyListeners();
  }
}
