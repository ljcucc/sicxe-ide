import 'dart:math';
import 'dart:typed_data';

import 'package:sicxe/utils/sicxe/emulator/floating_point.dart';
import 'package:sicxe/utils/sicxe/emulator/integer.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';
import 'package:sicxe/utils/sicxe/emulator/status_word.dart';
import 'package:sicxe/utils/sicxe/emulator/target_address.dart';

typedef Memory = Uint8List;

typedef DeviceOutputCallback = Function(int addr, int value);

class SICXE {
  Memory mem = Uint8List.fromList(
      List.generate(pow(2, 20).toInt(), (index) => 0xFF & index));
  ProgramCounter pc = ProgramCounter();
  IntegerData regA = IntegerData();
  IntegerData regX = IntegerData();
  IntegerData regL = IntegerData();
  StatusWord regSw = StatusWord();
  IntegerData regB = IntegerData();
  IntegerData regS = IntegerData();
  IntegerData regT = IntegerData();
  FloatingPointData regF = FloatingPointData();
  // Inspecting only
  Instruction? curInstruction;
  TargetAddress? ta;

  final DeviceOutputCallback? onOutput;

  SICXE({this.onOutput});

  Future<void> eval() async {
    // 1. Fetch instruction (pc++)
    final instruction = await pc.count(mem);
    print("${mem.length}, ${pc.get()}");
    // 2. Decode instruction
    if (instruction.format == InstructionFormat.Format3 ||
        instruction.format == InstructionFormat.Format4) {
      ta = TargetAddress(instruction, this);
    }

    curInstruction = instruction;
    print(curInstruction!.opcode);
    await Instructions[curInstruction!.opcode]!(this, ta!);

    print("eval end");
  }

  Map<String, dynamic> toMap() {
    return {
      // Registers
      "pc": pc,
      "regA": regA,
      "regX": regX,
      "regL": regL,
      "regSw": regSw,
      "regB": regB,
      "regS": regS,
      "regT": regT,

      // TargetAddress
      "operand_calc_disp": ta?.operandCalcDispToString(),

      // Instruction
      "instruction_flags": ta?.flagsToString() ?? "",
      "opcode_mnemonic": curInstruction?.opcode.name ?? "",
      "instruction_bytes": curInstruction?.bytes
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join()
          .toUpperCase(),
      "instruction_format": curInstruction?.format.name ?? "",
    };
  }
}

//TODO: remove Instruction fetch from here
class ProgramCounter extends IntegerData {
  Future<Instruction> count(Memory mem) async {
    int cur = get();

    // 1. fetch & parsing
    final instr = Instruction.fetch(mem, cur);

    // 2. counting up
    add(IntegerData()..set(instr.byteLength));

    // 3. retrun final instruction
    return instr;
  }

  @override
  ProgramCounter clone() {
    final copy = ProgramCounter();
    copy.set(get());
    return copy;
  }

  @override
  String toString() {
    return get().toRadixString(16);
  }
}
