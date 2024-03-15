import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

import 'package:google_fonts/google_fonts.dart';

class MemoryInspector extends StatefulWidget {
  const MemoryInspector({
    super.key,
  });

  @override
  State<MemoryInspector> createState() => _MemoryInspectorState();
}

class _MemoryInspectorState extends State<MemoryInspector> {
  TextEditingController _controller = TextEditingController(
    text: "0",
  );

  _offsetDecrease() {
    int value = int.tryParse(_controller.text, radix: 16) ?? 0;
    value -= 0x100;
    setState(() {
      _controller.text = max(value, 0).toRadixString(16).toUpperCase();
    });
  }

  _offsetIncrease() {
    int value = int.tryParse(_controller.text, radix: 16) ?? 0;
    value += 0x100;
    setState(() {
      _controller.text = value.toRadixString(16).toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
      final mem = emulator.getMemory();

      final offset = (int.tryParse(_controller.text, radix: 16) ?? 0);

      return Card(
        elevation: 0,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: _offsetIncrease,
                  icon: Icon(Icons.add_outlined),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: Material(
                    elevation: 4,
                    surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                    shadowColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        textAlign: TextAlign.center,
                        onChanged: (e) => setState(() {}),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _controller,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                IconButton.filledTonal(
                  // style: IconButton.styleFrom(
                  //     backgroundColor:
                  //         Theme.of(context).colorScheme.tertiaryContainer,
                  //     foregroundColor:
                  //         Theme.of(context).colorScheme.onTertiaryContainer),
                  onPressed: _offsetDecrease,
                  icon: Icon(Icons.remove_outlined),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                addAutomaticKeepAlives: false,
                itemCount: 0xFFF ~/ 8 + 1,
                itemBuilder: (context, index) {
                  final addressDisp =
                      (index * 8 + offset).toRadixString(16).toUpperCase();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Text(
                          "".padLeft(5 - addressDisp.length, "0"),
                          style: GoogleFonts.robotoMono(),
                        ),
                      ),
                      Text(
                        addressDisp,
                        style: GoogleFonts.robotoMono(),
                      ),
                      const SizedBox(width: 50),
                      Text(
                        mem
                            .getRange(
                                index * 8 + offset, index * 8 + 8 + offset)
                            .map((e) => e.toRadixString(16).padLeft(2, '0'))
                            .join(" ")
                            .toUpperCase(),
                        style: GoogleFonts.robotoMono(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
