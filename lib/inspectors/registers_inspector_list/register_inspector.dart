import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sicxe/binary_bar.dart';
import 'package:sicxe/vm/integer.dart';

class IntegerRegisterInspector extends StatelessWidget {
  final IntegerData reg;
  final String name;

  const IntegerRegisterInspector({
    super.key,
    required this.reg,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${name.padRight(5)} ",
          style: GoogleFonts.robotoMono(),
        ),
        BinaryBarView(
          binary: reg.get().toRadixString(2).padLeft(24, '0'),
        ),
      ],
    );
  }
}
