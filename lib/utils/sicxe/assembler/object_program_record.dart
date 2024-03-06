/// The job of ObjectProgramRecord is to keep and store all record data as a class
abstract class ObjectProgramRecord {
  String getRecord();
}

class ObjectCodeBlock {
  final String string;
  final String src;

  ObjectCodeBlock({required this.string, required this.src});

  @override
  String toString() {
    return string;
  }
}

class HeaderRecord extends ObjectProgramRecord {
  String programName = "";
  String startingAddress = "";
  String length = "";

  @override
  String getRecord() {
    return "H$programName$startingAddress$length\n";
  }
}

class TextRecord extends ObjectProgramRecord {
  String startingAddress = "000000";
  List<ObjectCodeBlock> blocks = [];

  bool add(ObjectCodeBlock objectCode) {
    if (length + objectCode.string.length > 60) return false;

    blocks.add(objectCode);
    return true;
  }

  int get length {
    if (blocks.isEmpty) return 0;
    int totalLength = blocks
        .map<int>((e) => e.string.length)
        .reduce((value, element) => value + element);
    return totalLength;
  }

  String get lengthString {
    return (length ~/ 2).toRadixString(16).padLeft(2, '0');
  }

  @override
  String getRecord() {
    var objectCodeString = blocks.join();
    return "T$startingAddress$lengthString$objectCodeString\n".toUpperCase();
  }
}

class EndRecord extends ObjectProgramRecord {
  String bootAddress = "";

  @override
  String getRecord() {
    return "E$bootAddress\n";
  }
}
