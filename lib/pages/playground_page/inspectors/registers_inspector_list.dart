import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/widgets/binary_bar.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';
import 'package:sicxe/widgets/overview_card.dart';
import 'package:sicxe/widgets/side_panel/side_panel_controller.dart';
import 'package:sicxe/widgets/value_block.dart';
import 'package:sicxe/utils/sicxe/emulator/integer.dart';
import 'package:sicxe/utils/sicxe/emulator/vm.dart';

class RegistersInspectorList extends StatelessWidget {
  final SICXE vm;

  const RegistersInspectorList({super.key, required this.vm});

  void openDocument(String docname, context) {
    final ddm = Provider.of<DocumentDisplayProvider>(context, listen: false);
    ddm.changeMarkdown(docname);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: ddm,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DocumentDisplayWidget(
                backgroundColor: Colors.transparent,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverviewCard(
      onInfoOpen: () => openDocument("registers.md", context),
      title: Text("Registers"),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          IntegerRegisterInspector(
            reg: vm.pc,
            name: "pc",
            onTap: () => openDocument("program_counter.md", context),
          ),
          IntegerRegisterInspector(
            reg: vm.regA,
            name: "regA",
            onTap: () => openDocument("reg_a.md", context),
          ),
          IntegerRegisterInspector(
            reg: vm.regX,
            name: "regX",
            onTap: () => openDocument("reg_x.md", context),
          ),
          IntegerRegisterInspector(
            reg: vm.regL,
            name: "regL",
            onTap: () => openDocument("reg_l.md", context),
          ),
          IntegerRegisterInspector(
            reg: vm.regSw,
            name: "regSw",
            onTap: () => openDocument("reg_sw.md", context),
          ),
          IntegerRegisterInspector(
            reg: vm.regB,
            name: "regB",
            onTap: () => openDocument("reg_b.md", context),
          ),
          IntegerRegisterInspector(
            reg: vm.regS,
            name: "regS",
            onTap: () => openDocument("reg_s.md", context),
          ),
          IntegerRegisterInspector(
            reg: vm.regT,
            name: "regT",
            onTap: () => openDocument("reg_t.md", context),
          ),
        ],
      ),
    );
  }
}

class IntegerRegisterInspector extends StatelessWidget {
  final IntegerData reg;
  final String name;
  final VoidCallback? onTap;

  const IntegerRegisterInspector({
    super.key,
    required this.reg,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueBlock(
      title: name,
      disp: reg.get().toRadixString(16).padLeft(6, '0'),
      onTap: onTap,
    );
  }
}
