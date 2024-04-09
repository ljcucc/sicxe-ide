import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/assembler/object_program_record.dart';
import 'package:sicxe/utils/sicxe/emulator/vm.dart';
import 'package:sicxe/utils/sicxe/loader/loader.dart';

/// Called "Simple Bootstrap Loader" in textbook
class SimpleLoader extends Loader {
  SimpleLoader({
    required super.vm,
    required super.assembler,
  });

  Future<void> load() async {
    final records = assembler.context.records;
    for (final (index, record) in records.indexed) {
      if (record is HeaderRecord) continue;
      if (record is ModificationRecord) continue;
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
          "loading to ${startingAddres + i}: ${tr.blocks.join("").substring(i * 2, (i + 1) * 2)}");
      vm.mem[startingAddres + i] = int.tryParse(
              tr.blocks.join("").substring(i * 2, (i + 1) * 2),
              radix: 16) ??
          0;
    }
  }
}
