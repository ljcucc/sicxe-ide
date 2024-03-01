import 'package:flutter/foundation.dart';
import 'package:sicxe/pages/timeline_page/timeline_data_list.dart';

class TimelineDataListsProvider extends ChangeNotifier {
  int totalLength = 0;
  Map<String, TimelineDataList> lists = {};

  add(Map<String, String> data) {
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
