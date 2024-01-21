import 'package:flutter/material.dart';
import 'package:sicxe/inspectors/registers_inspector_list/register_inspector.dart';
import 'package:sicxe/vm/vm.dart';

class RegistersInspectorList extends StatelessWidget {
  final SICXE vm;

  const RegistersInspectorList({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      child: ListTile(
        title: const Text("Registers"),
        subtitle: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
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
                reg: vm.pc,
                name: "pc",
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
        ),
      ),
    );
  }
}
