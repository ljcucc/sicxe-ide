import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/navigation_page_widget.dart';
import 'package:sicxe/pages/editor_page/editor_page.dart';
import 'package:sicxe/pages/home_page/home_page_compact.dart';
import 'package:sicxe/pages/inspector_page/inspector_page.dart';
import 'package:sicxe/pages/terminal_page/terminal_page.dart';
import 'package:sicxe/pages/timeline_page/timeline_page.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar_controller.dart';
import 'package:sicxe/screen_size.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_controller.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_widget.dart';
import 'package:sicxe/widgets/logo_widget.dart';

class CompactLayout extends StatelessWidget {
  const CompactLayout({
    super.key,
  });

  _openSidePanel(String id, context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => CustomPanelController(pageId: id),
            child: const CustomPanelWidget(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationPageProvider>(
        builder: (context, navPageProvider, child) {
      final pageId = navPageProvider.id;
      final pageIndexMap = [
        NavigationPageId.Home,
        NavigationPageId.Editor,
        NavigationPageId.Terminal,
        NavigationPageId.Inspector,
        NavigationPageId.Timeline,
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
              tooltip: "Widgets",
              icon: Icon(Icons.web_asset),
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () {
                    _openSidePanel("memory", context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.table_rows_outlined),
                    title: Text("Memory"),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    _openSidePanel("symtab", context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.view_list_outlined),
                    title: Text("Symbols"),
                  ),
                ),
              ],
            ),
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
                  child: NavigationPageView(),
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
              icon: Icon(Icons.draw_outlined),
              label: "Editor",
            ),
            NavigationDestination(
              icon: Icon(Icons.computer),
              label: "Terminal",
            ),
            NavigationDestination(
              icon: Icon(Icons.insert_chart_outlined),
              label: "Inspector",
            ),
            NavigationDestination(
              icon: Icon(Icons.graphic_eq),
              label: "Timeline",
            ),
          ],
        ),
      );
    });
  }
}
