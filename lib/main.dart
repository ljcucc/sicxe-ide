import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/compact_layout.dart';
import 'package:sicxe/custom_colorscheme_provider.dart';
import 'package:sicxe/large_layout.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:sicxe/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Providers(
      child: Consumer<CustomColorshcemeProvider>(
        builder: (context, colorschemeProvider, _) {
          var defaultColorScheme = ColorScheme.fromSeed(
            seedColor: colorschemeProvider.color,
            brightness: MediaQuery.of(context).platformBrightness,
          );

          if (kIsWeb) {
            return MaterialApp(
              title: 'SICXE VM',
              theme: ThemeData(
                colorScheme: defaultColorScheme,
                useMaterial3: true,
                brightness: MediaQuery.of(context).platformBrightness,
              ),
              home: MyHomePage(title: 'SICXE'),
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
              home: MyHomePage(title: 'SICXE'),
              debugShowCheckedModeBanner: false,
            );
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final compactLayout =
        MediaQuery.of(context).orientation == Orientation.portrait &&
            MediaQuery.of(context).size.width < 700;

    Widget body = (compactLayout) ? CompactLayout() : LargeLayout();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            stops: const [0.6, 1],
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}
