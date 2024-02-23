import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sicxe/widgets/binary_bar.dart';
import 'package:sicxe/widgets/overview_card.dart';
import 'package:sicxe/widgets/value_block.dart';
import 'package:sicxe/utils/vm/integer.dart';
import 'package:sicxe/utils/vm/vm.dart';

class RegistersInspectorList extends StatelessWidget {
  final SICXE vm;

  const RegistersInspectorList({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return OverviewCard(
      title: Text("Registers"),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          IntegerRegisterInspector(
            reg: vm.pc,
            name: "pc",
          ),
          IntegerRegisterInspector(
            reg: vm.regA,
            name: "regA",
          ),
          IntegerRegisterInspector(
            reg: vm.regX,
            name: "regX",
          ),
          IntegerRegisterInspector(
            reg: vm.regL,
            name: "regL",
          ),
          IntegerRegisterInspector(
            reg: vm.regSw,
            name: "regSw",
          ),
          IntegerRegisterInspector(
            reg: vm.regB,
            name: "regB",
          ),
          IntegerRegisterInspector(
            reg: vm.regS,
            name: "regS",
          ),
          IntegerRegisterInspector(
            reg: vm.regT,
            name: "regT",
          ),
        ],
      ),
    );
  }
}

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
    return ValueBlock(
      title: name,
      disp: reg.get().toRadixString(16).padLeft(5, '0'),
    );
  }
}
