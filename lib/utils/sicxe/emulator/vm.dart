import 'dart:math';
import 'dart:typed_data';

import 'package:sicxe/utils/sicxe/emulator/floating_point.dart';
import 'package:sicxe/utils/sicxe/emulator/integer.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';

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
  TargetAddress? ta;

  Future<void> eval() async {
    // 1. Fetch instruction (pc++)
    final instruction = await pc.count(mem);
    print("${mem.length}, ${pc.get()}");
    // 2. Decode instruction
    if (instruction.format == InstructionFormat.Format3 ||
        instruction.format == InstructionFormat.Format4) {
      ta = TargetAddress(instruction);
    }

    curInstruction = instruction;
    await Instructions[curInstruction!.opcode]!(this, ta!);

    print("eval end");
  }

  Map<String, dynamic> toMap() {
    return {
      "pc": pc,
      "regA": regA,
      "regX": regX,
      "regL": regL,
      "regSw": regSw,
      "regB": regB,
      "regS": regS,
      "regT": regT,
    };
  }
}

class TargetAddress {
  /// instruction n flag
  bool n = false;

  /// instruction i flag
  bool i = false;

  /// instruction x flag
  bool x = false;

  /// instruction b flag
  bool b = false;

  /// instruction p flag
  bool p = false;

  /// instruction e flag
  bool e = false;
  late Instruction _instruction;

  TargetAddress(Instruction instruction) {
    _instruction = instruction;
    if (instruction.format == InstructionFormat.Format2 ||
        instruction.format == InstructionFormat.Format1) {
      print("format 1 or format 2 does not have TA");
      return;
    }

    final bytes = instruction.bytes;

    int fstByte = bytes[0];
    int sndByte = bytes[1];

    print(
        "${fstByte.toRadixString(2).padLeft(8, '0')}-${sndByte.toRadixString(2).padLeft(8, '0')}");

    n = fstByte & 0x02 > 0;
    i = fstByte & 0x01 > 0;
    x = sndByte & 0x80 > 0;
    b = sndByte & 0x40 > 0;
    p = sndByte & 0x20 > 0;
    e = sndByte & 0x10 > 0;
  }

  /// check the instruction currently is simple addressing or not
  bool _isSimpleAddressing() {
    return !n && !i;
  }

  /// Get raw value in IntegerData directly.
  /// Different from getOperand(), this method is specially for OpCode operation implementation.
  IntegerData getDirectValue() {
    return IntegerData(value: getOperand());
  }

  /// get raw value from instruction operand field
  int getOperand() {
    if (_isSimpleAddressing()) {
      // block flag "x"
      int fstByte = _instruction.bytes[1] & 0x80;
      int sndByte = _instruction.bytes[2];

      print("TA result is ${fstByte << 8 | sndByte}");

      final result = fstByte << 8 | sndByte;
      return result;
    }

    return 0;
  }

  /// operating LOAD instructions
  IntegerData getIntegerData(SICXE vm) {
    final address = getOperand();
    final result =
        vm.mem[address] << 16 | vm.mem[address + 1] << 8 | vm.mem[address + 2];

    print("Fetched result is ${result}");

    return IntegerData(value: result);
  }

  /// operaitng STORE instructions
  void setIntegerData(IntegerData data, SICXE vm) {}

  /// return the flags status in string
  String flagsToString() {
    String disp = "";
    if (switch (_instruction.format) {
      InstructionFormat.Format1 || InstructionFormat.Format2 => true,
      InstructionFormat.Format3 || InstructionFormat.Format4 => false,
    }) return disp;

    disp += n ? "n" : "_";
    disp += i ? "i" : "_";
    disp += x ? "x" : "_";
    disp += b ? "b" : "_";
    disp += p ? "p" : "_";
    disp += e ? "e" : "_";

    return disp;
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

class Flag {
  final ByteData instruction;
  Flag(this.instruction);

  void isOn() {}
}
