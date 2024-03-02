import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xterm/xterm.dart';

class TerminalPage extends StatelessWidget {
  const TerminalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Terminal>(
      builder: (context, terminal, _) {
        final colorScheme = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.surface,
            ),
            padding: const EdgeInsets.all(16.0),
            child: TerminalView(
              terminal,
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
