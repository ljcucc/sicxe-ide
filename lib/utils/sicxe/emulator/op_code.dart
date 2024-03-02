import 'dart:typed_data';

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

typedef OpCallback = Future<void> Function(SICXE vm, TargetAddress ta);

final Map<OpCodes, OpCallback> Instructions = {
  OpCodes.ADD: (vm, ta) async {
    vm.regA.add(ta.getIntegerData(vm));
  },
  OpCodes.ADDF: (vm, ta) async {
    //TODO: implement ADDF operation
  },
  OpCodes.ADDR: (vm, ta) async {
    //TODO: implement ADDR operation
  },
  OpCodes.AND: (vm, ta) async {
    //TODO: implement AND operation
  },
  OpCodes.CLEAR: (vm, ta) async {
    //TODO: implement CLEAR operation
  },
  OpCodes.COMP: (vm, ta) async {
    //TODO: implement COMP operation
  },
  OpCodes.COMPF: (vm, ta) async {
    //TODO: implement COMPF operation
  },
  OpCodes.COMPR: (vm, ta) async {
    //TODO: implement COMPR operation
  },
  OpCodes.DIV: (vm, ta) async {
    //TODO: implement DIV operation
    vm.regA.sub(ta.getIntegerData(vm));
  },
  OpCodes.DIVF: (vm, ta) async {
    //TODO: implement DIVF operation
  },
  OpCodes.DIVR: (vm, ta) async {
    //TODO: implement DIVR operation
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
    vm.pc.set(ta.getOperand());
    print("setted pc by J");
  },
  OpCodes.JEQ: (vm, ta) async {
    //TODO: implement JEQ operation
  },
  OpCodes.JGT: (vm, ta) async {
    //TODO: implement JGT operation
  },
  OpCodes.JLT: (vm, ta) async {
    //TODO: implement JLT operation
  },
  OpCodes.JSUB: (vm, ta) async {
    //TODO: implement JSUB operation
  },
  OpCodes.LDA: (vm, ta) async {
    vm.regA.set(ta.getIntegerData(vm).get());
  },
  OpCodes.LDB: (vm, ta) async {
    vm.regB.set(ta.getIntegerData(vm).get());
  },
  OpCodes.LDCH: (vm, ta) async {
    //TODO: implement LDCH operation
  },
  OpCodes.LDF: (vm, ta) async {
    //TODO: implement LDF operation
  },
  OpCodes.LDL: (vm, ta) async {
    vm.regL.set(ta.getIntegerData(vm).get());
  },
  OpCodes.LDS: (vm, ta) async {
    vm.regS.set(ta.getIntegerData(vm).get());
  },
  OpCodes.LDT: (vm, ta) async {
    vm.regT.set(ta.getIntegerData(vm).get());
  },
  OpCodes.LDX: (vm, ta) async {
    vm.regX.set(ta.getIntegerData(vm).get());
  },
  OpCodes.LPS: (vm, ta) async {
    //TODO: implement LPS operation
  },
  OpCodes.MUL: (vm, ta) async {
    vm.regA.mul(ta.getIntegerData(vm));
  },
  OpCodes.MULF: (vm, ta) async {
    //TODO: implement MULF operation
  },
  OpCodes.MULR: (vm, ta) async {
    //TODO: implement MULR operation
  },
  OpCodes.NORM: (vm, ta) async {
    //TODO: implement NORM operation
  },
  OpCodes.OR: (vm, ta) async {
    //TODO: implement OR operation
  },
  OpCodes.RD: (vm, ta) async {
    //TODO: implement RD operation
  },
  OpCodes.RMO: (vm, ta) async {
    //TODO: implement RMO operation
  },
  OpCodes.RSUB: (vm, ta) async {
    //TODO: implement RSUB operation
  },
  OpCodes.SHIFTL: (vm, ta) async {
    //TODO: implement SHIFTL operation
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
    //TODO: implement STA operation
  },
  OpCodes.STB: (vm, ta) async {
    //TODO: implement STB operation
  },
  OpCodes.STCH: (vm, ta) async {
    //TODO: implement STCH operation
  },
  OpCodes.STF: (vm, ta) async {
    //TODO: implement STF operation
  },
  OpCodes.STI: (vm, ta) async {
    //TODO: implement STI operation
  },
  OpCodes.STL: (vm, ta) async {
    //TODO: implement STL operation
  },
  OpCodes.STS: (vm, ta) async {
    //TODO: implement STS operation
  },
  OpCodes.STSW: (vm, ta) async {
    //TODO: implement STSW operation
  },
  OpCodes.STT: (vm, ta) async {
    //TODO: implement STT operation
  },
  OpCodes.STX: (vm, ta) async {
    //TODO: implement STX operation
  },
  OpCodes.SUB: (vm, ta) async {
    vm.regA.sub(ta.getIntegerData(vm));
  },
  OpCodes.SUBF: (vm, ta) async {
    //TODO: implement SUBF operation
  },
  OpCodes.SUBR: (vm, ta) async {
    //TODO: implement SUBR operation
  },
  OpCodes.SVC: (vm, ta) async {
    //TODO: implement SVC operation
  },
  OpCodes.TD: (vm, ta) async {
    //TODO: implement TD operation
  },
  OpCodes.TIO: (vm, ta) async {
    //TODO: implement TIO operation
  },
  OpCodes.TIX: (vm, ta) async {
    //TODO: implement TIX operation
  },
  OpCodes.TIXR: (vm, ta) async {
    //TODO: implement TIXR operation
  },
  OpCodes.WD: (vm, ta) async {
    //TODO: implement WD operation
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
    final instrFormat2 = [
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

    final instrFormat1 = [
      OpCodes.FIX,
      OpCodes.FLOAT,
      OpCodes.HIO,
      OpCodes.NORM,
      OpCodes.SIO,
      OpCodes.TIO,
    ];

    if (instrFormat2.contains(opcode)) {
      return InstructionFormat.Format2;
    }

    if (instrFormat1.contains(opcode)) {
      return InstructionFormat.Format1;
    }

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
