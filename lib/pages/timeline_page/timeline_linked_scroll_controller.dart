import 'package:flutter/foundation.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class TimelineLinkedScrollController extends ChangeNotifier {
  late LinkedScrollControllerGroup controllers;

  TimelineLinkedScrollController() {
    controllers = LinkedScrollControllerGroup();
  }
}
