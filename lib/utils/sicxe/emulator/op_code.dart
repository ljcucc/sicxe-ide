import 'dart:typed_data';

import 'package:sicxe/utils/sicxe/emulator/integer.dart';
import 'package:sicxe/utils/sicxe/emulator/status_word.dart';
import 'package:sicxe/utils/sicxe/emulator/target_address.dart';
import 'package:sicxe/utils/sicxe/emulator/vm.dart';

enum OpCodes {
  ADD,
  ADDF,
  ADDR,
  AND,
  CLEAR,
  COMP,
  COMPF,
  COMPR,
  DIV,
  DIVF,
  DIVR,
  FIX,
  FLOAT,
  HIO,
  J,
  JEQ,
  JGT,
  JLT,
  JSUB,
  LDA,
  LDB,
  LDCH,
  LDF,
  LDL,
  LDS,
  LDT,
  LDX,
  LPS,
  MUL,
  MULF,
  MULR,
  NORM,
  OR,
  RD,
  RMO,
  RSUB,
  SHIFTL,
  SHIFTR,
  SIO,
  SSK,
  STA,
  STB,
  STCH,
  STF,
  STI,
  STL,
  STS,
  STSW,
  STT,
  STX,
  SUB,
  SUBF,
  SUBR,
  SVC,
  TD,
  TIO,
  TIX,
  TIXR,
  WD,
  OP_NOT_FOUND,
}

/// This list recorded all format2 opcodes
const instrFormat2 = [
  OpCodes.ADDR,
  OpCodes.CLEAR,
  OpCodes.COMPR,
  OpCodes.DIVR,
  OpCodes.MULR,
  OpCodes.RMO,
  OpCodes.SHIFTL,
  OpCodes.SHIFTR,
  OpCodes.SUBR,
  OpCodes.SVC,
  OpCodes.TIXR,
];

/// This list recorded all format1 opcodes
const instrFormat1 = [
  OpCodes.FIX,
  OpCodes.FLOAT,
  OpCodes.HIO,
  OpCodes.NORM,
  OpCodes.SIO,
  OpCodes.TIO,
];

typedef OpCallback = Future<void> Function(SICXE vm, TargetAddress ta);

final Map<OpCodes, OpCallback> Instructions = {
  OpCodes.ADD: (vm, ta) async {
    vm.regA.add(ta.getIntegerData());
  },
  OpCodes.ADDF: (vm, ta) async {
    //TODO: implement ADDF operation
  },
  OpCodes.ADDR: (vm, ta) async {
    final a = ta.getR1() ?? IntegerData();
    final b = ta.getR2() ?? IntegerData();

    b.set(b.get() + a.get());
  },
  OpCodes.AND: (vm, ta) async {
    final a = vm.regA;
    final b = ta.getIntegerData();

    a.set(a.get() & b.get());
  },
  OpCodes.CLEAR: (vm, ta) async {
    ta.getR1()?.set(0);
  },
  OpCodes.COMP: (vm, ta) async {
    // TODO: implement compare in IntegerData
    final a = vm.regA.get().toSigned(24);
    final b = ta.getIntegerData().get().toSigned(24);
    if (a > b) {
      vm.regSw.conditionCode = ConditionCode.GreaterThan;
    } else if (a < b) {
      vm.regSw.conditionCode = ConditionCode.LessThan;
    } else {
      vm.regSw.conditionCode = ConditionCode.Equal;
    }
  },
  OpCodes.COMPF: (vm, ta) async {
    //TODO: implement COMPF operation
  },
  OpCodes.COMPR: (vm, ta) async {
    final a = ta.getR1()?.get().toSigned(24) ?? 0;
    final b = ta.getR2()?.get().toSigned(24) ?? 0;

    if (a > b) {
      vm.regSw.conditionCode = ConditionCode.GreaterThan;
    } else if (a < b) {
      vm.regSw.conditionCode = ConditionCode.LessThan;
    } else {
      vm.regSw.conditionCode = ConditionCode.Equal;
    }
  },
  OpCodes.DIV: (vm, ta) async {
    try {
      vm.regA.div(ta.getIntegerData());
    } on UnsupportedError catch (e) {
      print(e);
    }
  },
  OpCodes.DIVF: (vm, ta) async {
    //TODO: implement DIVF operation
  },
  OpCodes.DIVR: (vm, ta) async {
    final a = ta.getR1() ?? IntegerData();
    final b = ta.getR2() ?? IntegerData();

    b.set(b.get() ~/ a.get());
  },
  OpCodes.FIX: (vm, ta) async {
    //TODO: implement FIX operation
  },
  OpCodes.FLOAT: (vm, ta) async {
    //TODO: implement FLOAT operation
  },
  OpCodes.HIO: (vm, ta) async {
    //TODO: implement HIO operation
  },
  OpCodes.J: (vm, ta) async {
    vm.pc.set(ta.getPrefetchedTa());
  },
  OpCodes.JEQ: (vm, ta) async {
    if (vm.regSw.conditionCode == ConditionCode.Equal) {
      final address = ta.getPrefetchedTa();
      vm.pc.set(address);
      // print("jump bc eq");
    }
  },
  OpCodes.JGT: (vm, ta) async {
    if (vm.regSw.conditionCode == ConditionCode.GreaterThan) {
      final address = ta.getPrefetchedTa();
      vm.pc.set(address);
      // print("jump bc gt");
    }
  },
  OpCodes.JLT: (vm, ta) async {
    if (vm.regSw.conditionCode == ConditionCode.LessThan) {
      final address = ta.getPrefetchedTa();
      vm.pc.set(address);
      // print("jump bc lt");
    }
  },
  OpCodes.JSUB: (vm, ta) async {
    vm.regL.set(vm.pc.get());
    // print("JSUB called");
    // print(ta.getPrefetchedTa().toRadixString(16));
    vm.pc.set(ta.getPrefetchedTa());
  },
  OpCodes.LDA: (vm, ta) async {
    vm.regA.set(ta.getIntegerData().get());
  },
  OpCodes.LDB: (vm, ta) async {
    vm.regB.set(ta.getIntegerData().get());
  },
  OpCodes.LDCH: (vm, ta) async {
    final byte = ta.getIntegerData().get() & 0xFF0000;
    int regAValue = vm.regA.get() & 0xFFFF00;
    regAValue |= (byte >> 16);
    vm.regA.set(regAValue);
  },
  OpCodes.LDF: (vm, ta) async {
    //TODO: implement LDF operation
  },
  OpCodes.LDL: (vm, ta) async {
    vm.regL.set(ta.getIntegerData().get());
  },
  OpCodes.LDS: (vm, ta) async {
    vm.regS.set(ta.getIntegerData().get());
  },
  OpCodes.LDT: (vm, ta) async {
    vm.regT.set(ta.getIntegerData().get());
  },
  OpCodes.LDX: (vm, ta) async {
    vm.regX.set(ta.getIntegerData().get());
  },
  OpCodes.LPS: (vm, ta) async {
    //TODO: implement LPS operation
  },
  OpCodes.MUL: (vm, ta) async {
    vm.regA.mul(ta.getIntegerData());
  },
  OpCodes.MULF: (vm, ta) async {
    //TODO: implement MULF operation
  },
  OpCodes.MULR: (vm, ta) async {
    final a = ta.getR1() ?? IntegerData();
    final b = ta.getR2() ?? IntegerData();

    b.set(b.get() * a.get());
  },
  OpCodes.NORM: (vm, ta) async {
    //TODO: implement NORM operation
  },
  OpCodes.OR: (vm, ta) async {
    final a = vm.regA;
    final b = ta.getIntegerData();

    a.set(a.get() | b.get());
  },
  OpCodes.RD: (vm, ta) async {
    print("Opcode RD!");
    final addr = (ta.getIntegerData(length: 1).get().toUnsigned(8));
    var value = 0;
    print("reading value from device: $addr");
    if (vm.inputBuffer.containsKey(addr) && vm.inputBuffer.isNotEmpty) {
      print("shift buffer");
      value = vm.inputBuffer[addr]!.first;
      vm.inputBuffer[addr]!.removeAt(0);
    }

    print(vm.inputBuffer[addr] ?? []);

    var calculated = vm.regA.get() & 0xFFFF00 | value;
    vm.regA.set(calculated);
  },
  OpCodes.RMO: (vm, ta) async {
    ta.getR2()?.set(ta.getR1()?.get() ?? 0);
  },
  OpCodes.RSUB: (vm, ta) async {
    vm.pc.set(vm.regL.get());
  },
  OpCodes.SHIFTL: (vm, ta) async {
    ta.getR1();
  },
  OpCodes.SHIFTR: (vm, ta) async {
    //TODO: implement SHIFTR operation
  },
  OpCodes.SIO: (vm, ta) async {
    //TODO: implement SIO operation
  },
  OpCodes.SSK: (vm, ta) async {
    //TODO: implement SSK operation
  },
  OpCodes.STA: (vm, ta) async {
    ta.setIntegerData(vm.regA);
  },
  OpCodes.STB: (vm, ta) async {
    ta.setIntegerData(vm.regB);
  },
  OpCodes.STCH: (vm, ta) async {
    ta.setIntegerData(IntegerData(
      value: vm.regA.get() & 0xFF,
    ));
  },
  OpCodes.STF: (vm, ta) async {
    //TODO: implement STF operation
  },
  OpCodes.STI: (vm, ta) async {
    //TODO: implement STI operation
  },
  OpCodes.STL: (vm, ta) async {
    ta.setIntegerData(vm.regL);
  },
  OpCodes.STS: (vm, ta) async {
    ta.setIntegerData(vm.regS);
  },
  OpCodes.STSW: (vm, ta) async {
    ta.setIntegerData(vm.regSw);
  },
  OpCodes.STT: (vm, ta) async {
    ta.setIntegerData(vm.regT);
  },
  OpCodes.STX: (vm, ta) async {
    ta.setIntegerData(vm.regX);
  },
  OpCodes.SUB: (vm, ta) async {
    vm.regA.sub(ta.getIntegerData());
  },
  OpCodes.SUBF: (vm, ta) async {
    //TODO: implement SUBF operation
  },
  OpCodes.SUBR: (vm, ta) async {
    final a = ta.getR1() ?? IntegerData();
    final b = ta.getR2() ?? IntegerData();

    b.set(b.get() - a.get());
  },
  OpCodes.SVC: (vm, ta) async {
    //TODO: implement SVC operation
  },
  OpCodes.TD: (vm, ta) async {
    final addr = (ta.getIntegerData(length: 1).get().toUnsigned(24));
    if (addr == 0x80) {
      vm.regSw.conditionCode = ConditionCode.None;
      return;
    }
    if (!vm.inputBuffer.containsKey(addr)) {
      vm.regSw.conditionCode = ConditionCode.Equal;
      return;
    }

    if (vm.inputBuffer[addr]!.isEmpty) {
      vm.regSw.conditionCode = ConditionCode.Equal;
      return;
    }

    vm.regSw.conditionCode = ConditionCode.None;
  },
  OpCodes.TIO: (vm, ta) async {
    //TODO: implement TIO operation
  },
  OpCodes.TIX: (vm, ta) async {
    // X++
    final regX = vm.regX;
    regX.set(regX.get() + 1);

    // compare
    final x = regX.get().toSigned(24);
    final a = ta.getIntegerData().get().toSigned(24);

    // print("compare with $x and $a");

    if (x > a) {
      vm.regSw.conditionCode = ConditionCode.GreaterThan;
    } else if (x < a) {
      vm.regSw.conditionCode = ConditionCode.LessThan;
    } else {
      vm.regSw.conditionCode = ConditionCode.Equal;
    }
  },
  OpCodes.TIXR: (vm, ta) async {
    // X++
    final regX = vm.regX;
    regX.set(regX.get() + 1);

    // compare
    final x = regX.get().toSigned(24);
    final a = ta.getR1()?.get().toSigned(24) ?? 0;

    if (x > a) {
      vm.regSw.conditionCode = ConditionCode.GreaterThan;
    } else if (x < a) {
      vm.regSw.conditionCode = ConditionCode.LessThan;
    } else {
      vm.regSw.conditionCode = ConditionCode.Equal;
    }
  },
  OpCodes.WD: (vm, ta) async {
    final deviceAddr = (ta.getIntegerData(length: 1).get().toUnsigned(24));
    final value = vm.regA.get() & 0xFF;
    // print("output device: $deviceAddr, $value");
    // print(ta.getIntegerData().get().toUnsigned(24).toRadixString(16));
    // print(deviceAddr.toRadixString(16));
    if (vm.onOutput != null) {
      vm.onOutput!(deviceAddr, value);
    } else {
      print("output is not defined");
    }
  },
};

final Map<int, OpCodes> DecodeTable = {
  // 0
  0x00: OpCodes.LDA,
  0x04: OpCodes.LDX,
  0x08: OpCodes.LDL,
  0x0C: OpCodes.STA,
  // 1
  0x10: OpCodes.STX,
  0x14: OpCodes.STL,
  0x18: OpCodes.ADD,
  0x1C: OpCodes.SUB,
  // 2
  0x20: OpCodes.MUL,
  0x24: OpCodes.DIV,
  0x28: OpCodes.COMP,
  0x2C: OpCodes.TIX,
  // 3
  0x30: OpCodes.JEQ,
  0x34: OpCodes.JGT,
  0x38: OpCodes.JLT,
  0x3C: OpCodes.J,
  // 4
  0x40: OpCodes.AND,
  0x44: OpCodes.OR,
  0x48: OpCodes.JSUB,
  0x4C: OpCodes.RSUB,
  // 5
  0x50: OpCodes.LDCH,
  0x54: OpCodes.STCH,
  0x58: OpCodes.ADDF,
  0x5C: OpCodes.SUBF,
  // 6
  0x60: OpCodes.MULF,
  0x64: OpCodes.DIVF,
  0x68: OpCodes.LDB,
  0x6C: OpCodes.LDS,
  // 7
  0x70: OpCodes.LDF,
  0x74: OpCodes.LDT,
  0x78: OpCodes.STB,
  0x7C: OpCodes.STS,
  // 8
  0x80: OpCodes.STF,
  0x84: OpCodes.STT,
  0x88: OpCodes.COMPF,
  // 9
  0x90: OpCodes.ADDR,
  0x94: OpCodes.SUBR,
  0x98: OpCodes.MULR,
  0x9C: OpCodes.DIVR,
  // A
  0xA0: OpCodes.COMPR,
  0xA4: OpCodes.SHIFTL,
  0xA8: OpCodes.SHIFTR,
  0xAC: OpCodes.RMO,
  // B
  0xB0: OpCodes.SVC,
  0xB4: OpCodes.CLEAR,
  0xB8: OpCodes.TIXR,
  // C
  0xC0: OpCodes.FLOAT,
  0xC4: OpCodes.FIX,
  0xC8: OpCodes.NORM,
  // D
  0xD0: OpCodes.LPS,
  0xD4: OpCodes.STI,
  0xD8: OpCodes.RD,
  0xDC: OpCodes.WD,
  // E
  0xE0: OpCodes.TD,
  0xE8: OpCodes.STSW,
  0xEC: OpCodes.SSK,
  // F
  0xF0: OpCodes.SIO,
  0xF4: OpCodes.HIO,
  0xF8: OpCodes.TIO,
};

enum InstructionFormat {
  Format1,
  Format2,
  Format3,
  Format4,
}

class Instruction {
  late InstructionFormat format;
  late OpCodes opcode;
  late Uint8List _bytes;

  Instruction(Uint8List instruction) {
    final int fstByte = instruction[0];
    final int opcodeByte = fstByte & 0xFC;

    _bytes = instruction;

    opcode = DecodeTable[opcodeByte] ?? OpCodes.OP_NOT_FOUND;
    format = _checkFormat(opcode, instruction);
  }

  set bytes(Uint8List byte) {
    _bytes = byte;
    format = _checkFormat(opcode, byte);
  }

  /// Stored raw bytes of full instruction and operand
  Uint8List get bytes {
    return _bytes;
  }

  int get byteLength {
    final formatMap = [
      InstructionFormat.Format1,
      InstructionFormat.Format2,
      InstructionFormat.Format3,
      InstructionFormat.Format4,
    ];
    final instrLen = formatMap.indexOf(format) + 1;

    return instrLen;
  }

  _checkFormat(OpCodes opcode, Uint8List instruction) {
    if (instrFormat2.contains(opcode)) {
      return InstructionFormat.Format2;
    }

    if (instrFormat1.contains(opcode)) {
      return InstructionFormat.Format1;
    }

    // SIC compatible foramt3
    if (instruction[0] & 0x03 == 0) {
      return InstructionFormat.Format3;
    }

    // checking flag E
    // if statement using mask 0x10: 00010000 -> xbpE....
    if (instruction[1] & 0x10 > 0) {
      return InstructionFormat.Format4;
    }

    return InstructionFormat.Format3;
  }

  static Instruction fetch(Memory mem, int cur) {
    // 1. fetch instruction temp
    final fetchedBytes =
        Uint8List.fromList(mem.getRange(cur, cur + 2).toList());

    // 2. parsing instruction temp
    final instruction = Instruction(fetchedBytes);

    // 3. counting next instruction by map
    final instrLen = instruction.byteLength;

    // 4. return final OpCode by refetching
    final fullInstr =
        Uint8List.fromList(mem.getRange(cur, cur + instrLen).toList());

    instruction.bytes = fullInstr;

    return instruction;
  }

  @override
  String toString() {
    return "${bytes}";
  }
}
