import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/top_segmented_buttons/number_display.dart';

class EmulatorClockAdjustButton extends StatelessWidget {
  const EmulatorClockAdjustButton({super.key});

  @override
  Widget build(BuildContext context) {
    openDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return Consumer<EmulatorWorkflow>(
              builder: (context, emulator, child) {
            TextEditingController controller = TextEditingController(
              text: emulator.clockHz.toString(),
            );
            return Dialog(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500, maxHeight: 100),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 1000,
                        value: emulator.clockHz.toDouble(),
                        onChanged: (value) {
                          emulator.clockHz = value.toInt();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Material(
                        elevation: 2,
                        surfaceTintColor:
                            Theme.of(context).colorScheme.surfaceTint,
                        shadowColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextField(
                            textAlign: TextAlign.center,
                            onEditingComplete: () => emulator.clockHz = min(
                              1000,
                              max(
                                1,
                                int.tryParse(controller.text) ??
                                    emulator.clockHz,
                              ),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: controller,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );
    }

    return Consumer<EmulatorWorkflow>(
      builder: (context, emulator, child) {
        return InkWell(
          onTap: openDialog,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: NumberDisplay(
              title: "Clock Rate",
              value: "${emulator.clockHz} Hz",
            ),
          ),
        );
      },
    );
  }
}
