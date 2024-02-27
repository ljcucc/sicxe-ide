import 'package:flutter/foundation.dart';
import 'package:sicxe/utils/vm/vm.dart';

class SicxeVmProvider extends ChangeNotifier {
  late SICXE vm;

  SicxeVmProvider() {
    vm = SICXE();
  }

  update() {
    notifyListeners();
  }
}
