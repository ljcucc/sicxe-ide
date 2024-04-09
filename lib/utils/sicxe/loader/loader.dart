import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/emulator/vm.dart';

/// template for all kinds of loaders
abstract class Loader {
  final SICXE vm;
  final LlbAssembler assembler;

  Loader({
    required this.vm,
    required this.assembler,
  });

  Future<void> load();
}
