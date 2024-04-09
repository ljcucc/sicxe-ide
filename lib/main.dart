import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/workspace_page/compact_layout.dart';
import 'package:sicxe/custom_colorscheme_provider.dart';
import 'package:sicxe/pages/workspace_page/large_layout.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:sicxe/pages/home_page/home_page.dart';
import 'package:sicxe/providers.dart';

void main() {
  // Paint.enableDithering = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorSchemeProvider = CustomColorshcemeProvider(
      Color.fromARGB(255, 246, 192, 58),
    );
    var defaultColorScheme = ColorScheme.fromSeed(
      seedColor: colorSchemeProvider.color,
      brightness: MediaQuery.of(context).platformBrightness,
    );

    return ChangeNotifierProvider(
      create: (_) => colorSchemeProvider,
      child: Consumer<CustomColorshcemeProvider>(
        builder: (context, colorschemeProvider, _) {
          if (kIsWeb) {
            return MaterialApp(
              title: 'SICXE VM',
              theme: ThemeData(
                colorScheme: defaultColorScheme,
                useMaterial3: true,
                brightness: MediaQuery.of(context).platformBrightness,
              ),
              home: HomePage(),
              debugShowCheckedModeBanner: false,
            );
          }

          return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
            final deviceColorScheme =
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? darkDynamic
                    : lightDynamic;

            return MaterialApp(
              title: 'SICXE VM',
              theme: ThemeData(
                colorScheme:
                    Platform.isAndroid ? deviceColorScheme : defaultColorScheme,
                useMaterial3: true,
              ),
              home: HomePage(),
              debugShowCheckedModeBanner: false,
            );
          });
        },
      ),
    );
  }
}
