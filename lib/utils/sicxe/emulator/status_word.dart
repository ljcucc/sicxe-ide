import 'package:sicxe/utils/sicxe/emulator/integer.dart';

enum ConditionCode {
  LessThan,
  Equal,
  GreaterThan,
  None,
}

enum KernelMode {
  User,
  Supervisor,
}

class StatusWord extends IntegerData {
  /// Set kernel mode
  set mode(KernelMode v) {
    int resetMask = 0x7FFFFF;
    int setMask = (v == KernelMode.User ? 0 : 1) << 23;

    set(get() & resetMask | setMask);
  }

  /// Get kernel mode
  KernelMode get mode => switch ((get() >> 23) & 0x1) {
        0 => KernelMode.User,
        1 => KernelMode.Supervisor,
        // TODO: Handle this case.
        int() => KernelMode.User,
      };

  // set idle(bool v) {}
  // get idle => ;

  // /// Process identifier
  // set id(int v) {}
  // get id  => ;

  /// condiction code
  set conditionCode(ConditionCode cc) {
    int resetMask = 0xFCFFFF;
    int setMask = switch (cc) {
          ConditionCode.LessThan => 1,
          ConditionCode.Equal => 2,
          ConditionCode.GreaterThan => 3,
          ConditionCode.None => 0,
        } <<
        16;

    set(get() & resetMask | setMask);
  }

  ConditionCode get conditionCode => switch (get() >> 16 & 0x3) {
        0 => ConditionCode.None,
        1 => ConditionCode.LessThan,
        2 => ConditionCode.Equal,
        3 => ConditionCode.GreaterThan,
        int() => ConditionCode.None,
      };

  // /// Interrupt mask
  // set mask(v) {}
  // get mask => ;

  // /// Interruption code
  // set icode(v) {}
  // get icode => ;
}
