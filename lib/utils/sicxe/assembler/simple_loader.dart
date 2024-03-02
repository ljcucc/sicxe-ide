import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/emulator/vm.dart';

/// Called "Simple Bootstrap Loader" in textbook

class SimpleLoader {
  final SICXE vm;
  final LlbAssembler assembler;

  SimpleLoader({
    required this.vm,
    required this.assembler,
  });

  Future<void> load() async {
    final records = assembler.records;
    for (final (index, record) in records.indexed) {
      if (record is HeaderRecord) continue;
      if (record is EndRecord) break;

      TextRecord tr = record as TextRecord;
      _loadTextRecordToMemory(tr);
    }
    vm.pc.set(
      int.tryParse((records.last as EndRecord).bootAddress, radix: 16) ?? 0,
    );
  }

  _loadTextRecordToMemory(TextRecord tr) {
    print(tr.getRecord());
    final startingAddres = int.tryParse(tr.startingAddress, radix: 16) ?? 0;
    for (int i = 0; i < tr.length / 2; i++) {
      print(
          "laoding to ${startingAddres + i}: ${tr.blocks.join("").substring(i * 2, (i + 1) * 2)}");
      vm.mem[startingAddres + i] = int.tryParse(
              tr.blocks.join("").substring(i * 2, (i + 1) * 2),
              radix: 16) ??
          0;
    }
  }
}
