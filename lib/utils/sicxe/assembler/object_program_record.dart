/// The job of ObjectProgramRecord is to keep and store all record data as a class
abstract class ObjectProgramRecord {
  /// return a pure string object code.
  String getRecord();

  /// return a JSON compatible list<Map> object
  List<Map<String, String>> toMapList();
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

  @override
  List<Map<String, String>> toMapList() {
    return [
      {
        'text': "H",
        'tooltip': "Header char, for HeaderRecord is [H]",
      },
      {
        'text': programName,
        'tooltip': "Program name",
      },
      {
        'text': startingAddress,
        'tooltip': "Staring address of object program.",
      },
      {
        'text': length,
        'tooltip': "Length of object program in bytes.",
      },
    ];
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

  @override
  List<Map<String, String>> toMapList() {
    return [
      {
        'text': "T",
        'tooltip': "Heading char, for TextRecord is [T]",
      },
      {
        'text': startingAddress,
        'tooltip': "Starting address for object code in this record.",
      },
      {
        'text': lengthString,
        'tooltip': "Length of object code in this record in bytes",
      },
      for (final block in blocks)
        {
          'tooltip': "ObjectCode: $block\nsrc: ${block.src}",
          'text': block.toString(),
        },
    ];
  }
}

class EndRecord extends ObjectProgramRecord {
  String bootAddress = "";

  @override
  String getRecord() {
    return "E$bootAddress\n";
  }

  @override
  List<Map<String, String>> toMapList() {
    return [
      {
        'tooltip': "Heading char, for EndRecord is [E]",
        "text": "E",
      },
      {
        "tooltip": "Starting address of this program",
        "text": bootAddress,
      },
    ];
  }
}

class ModificationRecord extends ObjectProgramRecord {
  final String startingLocation;
  final String digitLength;

  ModificationRecord({
    required this.startingLocation,
    required this.digitLength,
  });

  @override
  String getRecord() {
    return "M$startingLocation$digitLength\n";
  }

  @override
  List<Map<String, String>> toMapList() {
    return [
      {
        "tooltip": "Heading char, for ModificationRecord is [M]",
        "text": "M",
      },
      {
        "tooltip": "Starting location of the address",
        "text": startingLocation,
      },
      {
        "tooltip": "Length of modification in digits (half-bytes)",
        "text": digitLength,
      },
    ];
  }
}
