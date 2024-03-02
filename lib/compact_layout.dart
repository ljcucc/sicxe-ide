import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/navigation_page_widget.dart';
import 'package:sicxe/pages/assembler_page/assembler_page.dart';
import 'package:sicxe/pages/home_page/home_page_compact.dart';
import 'package:sicxe/pages/inspector_page/inspector_page.dart';
import 'package:sicxe/pages/terminal_page/terminal_page.dart';
import 'package:sicxe/pages/timeline_page/timeline_page.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar_controller.dart';
import 'package:sicxe/screen_size.dart';
import 'package:sicxe/widgets/logo_widget.dart';

class CompactLayout extends StatelessWidget {
  const CompactLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationPageProvider>(
        builder: (context, navPageProvider, child) {
      final pageId = navPageProvider.id;
      final pageIndexMap = [
        NavigationPageId.Home,
        NavigationPageId.Timeline,
        NavigationPageId.Inspector,
        NavigationPageId.Terminal,
        NavigationPageId.Assembler,
      ];

      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 65,
          surfaceTintColor: Colors.transparent,
          // leading: IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.menu),
          // ),
          title: LogoWidget(
            compact: true,
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () {},
                  child: ListTile(
                    title: Text("Help"),
                    leading: Icon(Icons.help_outline),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {},
                  child: ListTile(
                    title: Text("Settings"),
                    leading: Icon(Icons.settings_outlined),
                  ),
                )
              ],
            ),
          ],
        ),
        body: Provider.value(
          value: ScreenSize.Compact,
          child: const Center(
            child: Column(
              children: [
                Expanded(
                  child: NavigationPageWidget(),
                ),
                TimingControlBar(
                  compact: true,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          selectedIndex: max(pageIndexMap.indexOf(pageId), 0),
          onDestinationSelected: (index) {
            navPageProvider.id = pageIndexMap[index];
            Provider.of<TimingControlBarController>(context, listen: false)
                    .enable =
                navPageProvider.id == NavigationPageId.Timeline ||
                    navPageProvider.id == NavigationPageId.Inspector;
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.graphic_eq),
              label: "Timeline",
            ),
            NavigationDestination(
              icon: Icon(Icons.memory_rounded),
              label: "Inspector",
            ),
            NavigationDestination(
              icon: Icon(Icons.monitor),
              label: "Terminal",
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_rounded),
              label: "Assembler",
            ),
          ],
        ),
      );
    });
  }
}
