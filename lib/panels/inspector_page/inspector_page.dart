import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/screen_size.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/overview_card.dart';
import 'package:sicxe/widgets/value_block.dart';

class InspectorPage extends StatelessWidget {
  final EdgeInsets padding;
  const InspectorPage({
    super.key,
    this.padding = const EdgeInsets.only(right: 16, left: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenSize>(builder: (context, screenSize, _) {
      return Consumer<EmulatorWorkflow>(
        builder: (context, emulator, child) {
          final inspectorContent = emulator.toInspectorMap();
          final color = Theme.of(context).colorScheme.onSurface;
          final bordercolor =
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5);

          return Container(
            padding: padding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: switch (screenSize) {
                      ScreenSize.Compact => 64,
                      ScreenSize.Large => 16,
                      ScreenSize.Medium => 16,
                    },
                  ),
                  for (final key in inspectorContent.keys)
                    Container(
                      padding: EdgeInsets.only(bottom: 60, left: 8, right: 8),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            key,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: color,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 24),
                          for (final sectionKey in inspectorContent[key]!.keys)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    // border: Border(
                                    //   bottom: BorderSide(
                                    //     color: bordercolor,
                                    //     width: 1,
                                    //   ),
                                    // ),
                                    ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        sectionKey,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        inspectorContent[key]![sectionKey] ??
                                            "",
                                        style: GoogleFonts.spaceMono(
                                          fontSize: 16,
                                          color: color,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
