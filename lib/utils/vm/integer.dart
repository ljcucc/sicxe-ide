class IntegerData {
  int _value = 0x0;

  set(int value) {
    _value = value.toUnsigned(24);
  }

  add(IntegerData integer) {
    _value = integer._value + _value;
    _value = _value.toUnsigned(24);
  }

  sub(IntegerData integer) {
    _value = integer._value - _value;
    _value = _value.toUnsigned(24);
  }

  mul(IntegerData integer) {
    _value = integer._value * _value;
    _value = _value.toUnsigned(24);
  }

  div(IntegerData integer) {
    _value = integer._value ~/ _value;
    _value = _value.toUnsigned(24);
  }

  int get() {
    return _value;
  }

  IntegerData clone() {
    final copy = IntegerData();
    copy.set(_value);
    return copy;
  }
}
