class TimelineDataBlock {
  int length;
  String value;

  TimelineDataBlock({
    required this.length,
    required this.value,
  });
}

class TimelineDataList {
  String name;
  List<TimelineDataBlock> blocks = [];

  TimelineDataList({required this.name});

  add(String value) {
    if (blocks.isNotEmpty && blocks.last.value == value) {
      blocks.last.length++;
      print("value repeated at ${name}");
      return;
    }
    if (blocks.isNotEmpty) {
      print("value is not repeat at ${name}");
      print("${blocks.last.value} vs ${value}");
    }

    blocks.add(TimelineDataBlock(
      length: 1,
      value: value,
    ));
  }
}
