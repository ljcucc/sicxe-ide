import 'package:flutter/foundation.dart';
import 'package:sicxe/pages/timeline_page/timeline_data_list.dart';

class TimelineDataListsProvider extends ChangeNotifier {
  bool _enable = false;

  set enable(bool e) {
    _enable = e;
    notifyListeners();
  }

  bool get enable => _enable;

  int totalLength = 0;
  Map<String, TimelineDataList> lists = {};

  add(Map<String, String> data) {
    if (!_enable) {
      return;
    }
    totalLength++;
    for (final key in data.keys) {
      if (!lists.containsKey(key)) {
        lists[key] = TimelineDataList(name: key);
      }

      lists[key]?.add(data[key] ?? "");
    }

    notifyListeners();
  }

  reset() {
    lists = {};
    totalLength = 0;
    notifyListeners();
  }
}
