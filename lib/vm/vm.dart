import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:sicxe/vm/floating_point.dart';
import 'package:sicxe/vm/integer.dart';
import 'package:sicxe/vm/op_code.dart';

typedef Memory = Uint8List;

class SICXE {
  Memory mem = Uint8List.fromList(
      List.generate(pow(2, 20).toInt(), (index) => 0xFF & index));
  ProgramCounter pc = ProgramCounter();
  IntegerData regA = IntegerData();
  IntegerData regX = IntegerData();
  IntegerData regL = IntegerData();
  IntegerData regSw = IntegerData();
  IntegerData regB = IntegerData();
  IntegerData regS = IntegerData();
  IntegerData regT = IntegerData();
  FloatingPointData regF = FloatingPointData();
  // Inspecting only
  Instruction? curInstruction;

  Future<void> eval() async {
    // 1. Fetch instruction (pc++)
    final instruction = await pc.count(mem);
    print("${mem.length}, ${pc.get()}");
    // 2. Decode instruction
    if (instruction.format == InstructionFormat.Format3 ||
        instruction.format == InstructionFormat.Format4) {
      TargetAddress ta = TargetAddress(instruction);
    }

    curInstruction = instruction;
  }
}

class TargetAddress {
  bool n = false;
  bool i = false;
  bool x = false;
  bool b = false;
  bool p = false;
  bool e = false;

  TargetAddress(Instruction instruction) {
    if (instruction.format == InstructionFormat.Format2 ||
        instruction.format == InstructionFormat.Format1) {
      print("format 1 or format 2 does not have TA");
      return;
    }

    final bytes = instruction.bytes;

    int fstByte = bytes[0];
    int sndByte = bytes[1];

    n = fstByte & 0x02 > 0;
    i = fstByte & 0x01 > 0;
    x = sndByte & 0x80 > 0;
    b = sndByte & 0x40 > 0;
    p = sndByte & 0x20 > 0;
    e = sndByte & 0x10 > 0;
  }

  IntegerData getIntegerData() {
    return IntegerData();
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
}

class Flag {
  final ByteData instruction;
  Flag(this.instruction);

  void isOn() {}
}