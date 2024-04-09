import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/terminal_page/terminal_controller.dart';
import 'package:sicxe/utils/sicxe/sicxe_emulator_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:xterm/xterm.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmulatorWorkflow>(
      builder: (context, emulator, _) {
        final terminal = emulator.terminal;
        final colorScheme = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.05),
                  spreadRadius: 0,
                  blurRadius: 25,
                )
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: TerminalView(
              terminal,
              textScaler: TextScaler.linear(1.1),
              theme: TerminalTheme(
                cursor: colorScheme.primary,
                selection: colorScheme.primary,
                foreground: colorScheme.onSurface,
                background: colorScheme.surface,
                black: colorScheme.onSurface,
                white: colorScheme.surface,
                red: Colors.red.harmonizeWith(colorScheme.primary),
                green: Colors.green.harmonizeWith(colorScheme.primary),
                yellow: Colors.yellow.harmonizeWith(colorScheme.primary),
                blue: Colors.blue.harmonizeWith(colorScheme.primary),
                magenta: Colors.pink.harmonizeWith(colorScheme.primary),
                cyan: Colors.cyan.harmonizeWith(colorScheme.primary),
                brightBlack: Colors.black.harmonizeWith(colorScheme.primary),
                brightRed: Colors.red.harmonizeWith(colorScheme.primary),
                brightGreen: Colors.green.harmonizeWith(colorScheme.primary),
                brightYellow: Colors.yellow.harmonizeWith(colorScheme.primary),
                brightBlue: Colors.blue.harmonizeWith(colorScheme.primary),
                brightMagenta: Colors.pink.harmonizeWith(colorScheme.primary),
                brightCyan: Colors.cyan.harmonizeWith(colorScheme.primary),
                brightWhite: Colors.white.harmonizeWith(colorScheme.primary),
                searchHitBackground: Colors.transparent,
                searchHitBackgroundCurrent: Colors.transparent,
                searchHitForeground: Colors.transparent,
              ),
            ),
          ),
        );
      },
    );
  }
}
