import 'package:sicxe/utils/sicxe/emulator/integer.dart';
import 'package:sicxe/utils/sicxe/emulator/op_code.dart';
import 'package:sicxe/utils/sicxe/emulator/vm.dart';

/// Addressing type defined by flags n,i.
enum AddressingType {
  /// Simple addressing, ni = 11, none of the flags will be ignored.
  /// Calculation: (addr) or (disp)
  Simple,

  /// Indirect addressing, ni = 10
  /// Calculation: ((addr)) or ((disp))
  Indirect,

  /// Immediate addressing, ni = 01
  /// Calculation: addr or disp
  Immediate,

  /// Simple addressing, ni = 00,  but compatible with SIC. which means program will ignore flags n,i and b,p,e.
  /// Calculation: (b|p|e|disp)
  SimpleCompatible,
}

/// TargetAddress class
/// decode instructions, calculate operand, TA...
class TargetAddress {
  SICXE vm;

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

  TargetAddress(Instruction instruction, this.vm) {
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

  AddressingType getAddressingType() {
    if (!n && !i) {
      return AddressingType.SimpleCompatible;
    }

    if (n == i) {
      return AddressingType.Simple;
    }

    if (i) {
      return AddressingType.Immediate;
    }

    // n == 1
    return AddressingType.Indirect;
  }

  /// Get value from instruction address or dipslay field.
  /// This method is not compatible with SIC compatible display
  ///
  /// for e = 0, will be disp.
  /// for e = 1, will be addr.
  int getAddressDisplay() {
    // format 4
    if (_instruction.format == InstructionFormat.Format4) {
      // mask: 0000 1111 1111 1111 1111 1111
      return _instruction.bytes[1] & 0x0F << 16 |
          _instruction.bytes[2] << 8 |
          _instruction.bytes[3];
    }

    // format 3
    // mask: 0000 1111 1111 1111
    return ((_instruction.bytes[1] & 0x0F) << 8) | _instruction.bytes[2];
  }

  /// Get the insturction display value for AddressingType.SimpleCompatible
  /// which will ignore flags n,i,b,p,e and get the final value.
  int getCompatibleDisplay() {
    final bytes = _instruction.bytes;

    // block flag "x"
    return (bytes[1] & 0x7F) << 8 | bytes[2];
  }

  /// Get TA value.
  /// This value will used differently from STORE to LOAD type operation.
  /// If it's STORE operation, TA will be the address to store
  /// If it's LOAD operation, TA will be the address to fetch
  int getCalculatedTaValue() {
    final type = getAddressingType();

    // simple compatible address will only be format 3.
    if (type == AddressingType.SimpleCompatible) {
      return getCompatibleDisplay();
    }

    int taValue = getAddressDisplay();
    if (x) {
      print("ta mode: index");
      taValue += vm.regX.get();
    }
    if (b) {
      print("ta mode: base based");
      taValue = taValue.toSigned(12) + vm.regB.get();
    }
    if (p) {
      print(
          "ta mode: pc based, ${taValue.toRadixString(16)} = ${taValue.toSigned(12)} + ${vm.pc.get()}");
      taValue = taValue.toSigned(12) + vm.pc.get();
    }

    return taValue;
  }

  /// get the prefetched TA value if type == AddressingType.Indirect
  ///
  /// for J, JLT, JGT, (TA) value means the location to jumped at.
  /// so the Immediate addressing will be meaningless since pure value isn't a place to jump at.
  /// Also apply to STORE operation.
  int getPrefetchedTa() {
    final type = getAddressingType();
    final address = getCalculatedTaValue();
    if (type == AddressingType.Indirect) {
      return _fetchFromMemory(address);
    }

    return address;
  }

  /// Fetch a word value from emulator memory
  _fetchFromMemory(int address, {int length = 3}) {
    final memLength = vm.mem.length;
    if (address >= memLength || address < 0) {
      print("address out of range: $address");
      return 0;
    }
    var result = 0;
    for (int i = 0; i < length; i++) {
      result <<= 8;
      result |= vm.mem[address + i];
    }
    return result;
  }

  /// Store back a word value to emulator memory
  _storeToMemory(int address, int value) {
    final length = vm.mem.length;
    if (address >= length || address < 0) {
      print("address out of range: $address");
      return 0;
    }
    for (int i = 0; i <= 3; i++) {
      vm.mem[address + 2 - i] = value & 0xFF;
      value >>= 8;
    }
  }

  /// operating LOAD instructions, which will calculate the TA and Operand, and return IntegerData object.
  IntegerData getIntegerData({
    int length = 3,
  }) {
    final type = getAddressingType();

    // operate: TA
    if (type == AddressingType.Immediate) {
      final address = getCalculatedTaValue();
      return IntegerData(value: address);
    }

    // operate: ((TA)) or (TA)
    return IntegerData(
      value: _fetchFromMemory(
        getPrefetchedTa(),
        length: length,
      ),
    );
  }

  /// operaitng STORE instructions
  void setIntegerData(IntegerData data) {
    final type = getAddressingType();

    if (type == AddressingType.Immediate) {
      print("undefined behavior, X3");
      return;
    }

    _storeToMemory(getPrefetchedTa(), data.get());
  }

  IntegerData? getRegisterByIndex(int index) {
    final mappingList = <IntegerData>[
      vm.regA,
      vm.regX,
      vm.regL,
      vm.regB,
      vm.regS,
      vm.regT,
      IntegerData(), // regF
      IntegerData(), // ???
      vm.pc,
      vm.regSw,
    ];

    return mappingList[index];
  }

  IntegerData? getR1() {
    if (_instruction.format != InstructionFormat.Format2) return null;

    final index = _instruction.bytes[1] & 0xF0 >> 4;
    return getRegisterByIndex(index);
  }

  IntegerData? getR2() {
    if (_instruction.format != InstructionFormat.Format2) return null;

    final index = _instruction.bytes[1] & 0x0F;
    return getRegisterByIndex(index);
  }

  /// return the flags status in string
  String flagsToString() {
    final type = getAddressingType();

    String disp = "";
    if (switch (_instruction.format) {
      InstructionFormat.Format1 || InstructionFormat.Format2 => true,
      InstructionFormat.Format3 || InstructionFormat.Format4 => false,
    }) return disp;

    if (type == AddressingType.SimpleCompatible) {
      return x ? "x" : "_";
    }

    disp += n ? "n" : "_";
    disp += i ? "i" : "_";
    disp += x ? "x" : "_";
    disp += b ? "b" : "_";
    disp += p ? "p" : "_";
    disp += e ? "e" : "_";

    return disp;
  }

  /// return the operand calculation display in string
  String operandCalcDispToString() {
    final type = getAddressingType();

    String taDisp = switch (_instruction.format) {
      InstructionFormat.Format3 => "disp",
      InstructionFormat.Format4 => "addr",
      InstructionFormat.Format1 => "",
      InstructionFormat.Format2 => "",
    };

    if (b) {
      taDisp += " + (B)";
    }

    if (p) {
      taDisp += " + (P)";
    }

    if (type == AddressingType.SimpleCompatible) {
      taDisp = "b/p/e/disp";
    }

    if (x) {
      taDisp += " + (X)";
    }

    return switch (type) {
      AddressingType.Simple || AddressingType.SimpleCompatible => "( $taDisp )",
      // TODO: Handle this case.
      AddressingType.Indirect => "(( $taDisp ))",
      // TODO: Handle this case.
      AddressingType.Immediate => taDisp,
    };
  }
}
