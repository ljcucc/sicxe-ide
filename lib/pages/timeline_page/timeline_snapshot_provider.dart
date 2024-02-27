import 'package:flutter/foundation.dart';
import 'package:sicxe/utils/vm/vm.dart';

class TimelineSnapshotProvider extends ChangeNotifier {
  List<SICXE> snapshots = [];

  TimelineSnapshotProvider() {
    final initState = SICXE();

    snapshots.add(initState);
  }

  push(SICXE snapshot) {
    snapshots.add(snapshot);
    notifyListeners();
  }
}
