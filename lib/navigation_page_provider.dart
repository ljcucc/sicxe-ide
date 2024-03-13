import 'package:flutter/material.dart';

enum NavigationPageId {
  Home,
  Assets,
  Timeline,
  Inspector,
  Terminal,
  Editor,
}

class NavigationPageProvider extends ChangeNotifier {
  NavigationPageId _pageId = NavigationPageId.Assets;

  NavigationPageId get id {
    return _pageId;
  }

  set id(NavigationPageId id) {
    _pageId = id;
    notifyListeners();
  }
}
