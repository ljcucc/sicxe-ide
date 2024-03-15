import 'package:flutter/material.dart';

class EditorTabController extends ChangeNotifier {
  String _tabId = "main.asm";
  List<String> openedTabs = ["main.asm", "output.asm"];

  set tabId(String id) {
    _tabId = id;
    notifyListeners();
  }

  String get tabId {
    return _tabId;
  }

  openTab(
    String id, {
    bool setTab = true,
  }) {
    if (setTab) tabId = id;
    if (openedTabs.contains(id)) return;
    openedTabs.add(id);
    notifyListeners();
  }

  bool closeTab(String id) {
    if (!openedTabs.contains(id)) return false;

    openedTabs.remove(id);
    _tabId = openedTabs.last;

    notifyListeners();

    return true;
  }
}
