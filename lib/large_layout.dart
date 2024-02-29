import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/assembler_page.dart';
import 'package:sicxe/pages/home_page/home_page.dart';
import 'package:sicxe/pages/playground_page/playground_page.dart';
import 'package:sicxe/pages/settings_page/settings_page.dart';
import 'package:sicxe/pages/timeline_page/timeline_page.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar.dart';
import 'package:sicxe/screen_size.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';
import 'package:sicxe/widgets/logo_widget.dart';

class LargeLayout extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onSelected;

  const LargeLayout({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final maxIndex = 3;
    final selectedPage = switch (selectedIndex) {
      0 => const HomePage(),
      1 => const TimelinePage(),
      2 => const PlaygroundPage(),
      3 => AssemblerPage(),
      int() => AssemblerPage(),
    };

    // final trailingButtons =
    //     Consumer<DocumentDisplayProvider>(builder: (context, ddm, _) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       IconButton(
    //         onPressed: () {
    //           ddm.enable = !ddm.enable;
    //           print(ddm.enable);
    //         },
    //         icon: Icon(ddm.enable ? Icons.help : Icons.help_outline),
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.settings_outlined),
    //         onPressed: () {
    //           Navigator.of(context).push(MaterialPageRoute(
    //             builder: (context) => SettingsPage(
    //               backgroundColor: Theme.of(context).colorScheme.background,
    //             ),
    //           ));
    //         },
    //       ),
    //       SafeArea(
    //         minimum: EdgeInsets.only(bottom: 16),
    //         child: Container(),
    //       ),
    //     ],
    //   );
    // });

    final navigationRail = NavigationRail(
      backgroundColor: Colors.transparent,
      onDestinationSelected: onSelected,
      groupAlignment: 0,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text("Home"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.graphic_eq),
          label: Text("Timeline"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.memory_rounded),
          label: Text("Inspector"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.auto_awesome_rounded),
          label: Text("Assembler"),
        ),
      ],
      selectedIndex: min(selectedIndex, maxIndex),
    );

    final documentDisplay =
        Consumer<DocumentDisplayProvider>(builder: (context, ddm, _) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutQuart,
        width: ddm.enable ? 400 : 0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.only(right: 8),
            width: 400,
            child: DocumentDisplayWidget(),
          ),
        ),
      );
    });

    final screenSize = MediaQuery.of(context).size;

    return Consumer<DocumentDisplayProvider>(builder: (context, ddm, _) {
      return Provider.value(
        value: screenSize.width < 1200 ? ScreenSize.Medium : ScreenSize.Large,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  navigationRail,
                  Expanded(
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        toolbarHeight: 80,
                        surfaceTintColor: Colors.transparent,
                        title: LogoWidget(),
                        centerTitle: true,
                        actions: [
                          IconButton(
                            onPressed: () {
                              ddm.enable = !ddm.enable;
                              print(ddm.enable);
                            },
                            icon: Icon(
                                ddm.enable ? Icons.help : Icons.help_outline),
                          ),
                          IconButton(
                            icon: Icon(Icons.settings_outlined),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SettingsPage(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ));
                            },
                          ),
                        ],
                      ),
                      body: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: selectedPage),
                          documentDisplay,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TimingControlBar(),
          ],
        ),
      );
    });
  }
}
