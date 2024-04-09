import 'package:flutter/material.dart';

class EditorTabController extends ChangeNotifier {
  int changed = 0;
  String _tabId = "";
  List<String> openedTabs = [];

  update() {
    changed++;
    notifyListeners();
  }

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
    if (openedTabs.length >= 1) {
      _tabId = openedTabs.last;
    } else {
      _tabId = "";
    }

    notifyListeners();

    return true;
  }
}
