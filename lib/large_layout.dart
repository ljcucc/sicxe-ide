import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/navigation_page_widget.dart';
import 'package:sicxe/pages/editor_page/editor_page.dart';
import 'package:sicxe/pages/home_page/home_page.dart';
import 'package:sicxe/pages/inspector_page/inspector_page.dart';
import 'package:sicxe/pages/settings_page/settings_page.dart';
import 'package:sicxe/pages/terminal_page/terminal_page.dart';
import 'package:sicxe/pages/timeline_page/timeline_page.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar_controller.dart';
import 'package:sicxe/screen_size.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_controller.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_widget.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';
import 'package:sicxe/widgets/large_screen_navigation_rail.dart';
import 'package:sicxe/widgets/logo_widget.dart';
import 'package:sicxe/widgets/side_panel/side_panel_controller.dart';
import 'package:sicxe/widgets/side_panel/side_panel_widget.dart';
import 'package:sicxe/widgets/time_control_segmented_buttons.dart';

class LargeLayout extends StatelessWidget {
  const LargeLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _setPage(NavigationPageId id) {
      final documentFilenames = {
        NavigationPageId.Home: "README.md",
        NavigationPageId.Timeline: "emulator.md",
        NavigationPageId.Terminal: "emulator.md",
        NavigationPageId.Editor: "assembler_language.md"
      };

      Provider.of<DocumentDisplayProvider>(context, listen: false)
          .changeMarkdown(
        documentFilenames[id]!,
      );

      // Provider.of<TimingControlBarController>(context, listen: false).enable =
      //     id == NavigationPageId.Timeline;
    }

    return Consumer<NavigationPageProvider>(
      builder: (context, navPageProvider, child) {
        final pageId = navPageProvider.id;

        final pageIndexMap = [
          NavigationPageId.Home,
          NavigationPageId.Editor,
          NavigationPageId.Terminal,
          NavigationPageId.Timeline,
        ];

        if (!pageIndexMap.contains(pageId)) {
          navPageProvider.id = NavigationPageId.Home;
          _setPage(NavigationPageId.Home);
        }

        final navigationRail = LargeScreenNavigationRail(
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
              icon: Icon(Icons.computer_outlined),
              label: "Terminal",
            ),
            NavigationDestination(
              icon: Icon(Icons.graphic_eq),
              label: "Timeline",
            ),
            // Icons.home,
            // Icons.code_rounded,
            // Icons.monitor,
            // Icons.graphic_eq,
          ],
          selectedIndex: max(pageIndexMap.indexOf(pageId), 0),
          onDestinationSelected: (index) {
            navPageProvider.id = pageIndexMap[index];
            _setPage(navPageProvider.id);
          },
        );

        // final navigationRail = NavigationRail(
        //   backgroundColor: Colors.transparent,
        //   onDestinationSelected: (index) {
        //     navPageProvider.id = pageIndexMap[index];
        //     _setPage(navPageProvider.id);
        //   },
        //   groupAlignment: 0,
        //   labelType: NavigationRailLabelType.none,
        //   indicatorShape: CircleBorder(),
        //   destinations: const [
        //     NavigationRailDestination(
        //       icon: Icon(Icons.home),
        //       label: Text("Home"),
        //     ),
        //     NavigationRailDestination(
        //       icon: Icon(Icons.code_rounded),
        //       label: Text("Editor"),
        //     ),
        //     NavigationRailDestination(
        //       icon: Icon(Icons.monitor),
        //       label: Text("Terminal"),
        //     ),
        //     NavigationRailDestination(
        //       icon: Icon(Icons.graphic_eq),
        //       label: Text("Timeline"),
        //     ),
        //   ],
        //   selectedIndex: max(pageIndexMap.indexOf(pageId), 0),
        // );

        final screenSize = MediaQuery.of(context).size;

        return Consumer<SidePanelController>(
            builder: (context, sidePanelController, _) {
          return Provider.value(
            value:
                screenSize.width < 1200 ? ScreenSize.Medium : ScreenSize.Large,
            child: Row(
              children: [
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      toolbarHeight: 80,
                      surfaceTintColor: Colors.transparent,
                      title: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TimeControlSegmentedButtons(),
                      ),
                      centerTitle: true,
                      actions: [
                        IconButton(
                          tooltip: "View sidebar",
                          onPressed: () {
                            sidePanelController.toggle();
                          },
                          icon: Icon(
                            sidePanelController.isOpen
                                ? Icons.view_sidebar
                                : Icons.view_sidebar_outlined,
                          ),
                        ),
                        SizedBox(width: 8),
                        PopupMenuButton(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          itemBuilder: (_) => <PopupMenuEntry<dynamic>>[
                            PopupMenuItem(
                              onTap: () {
                                Provider.of<SidePanelController>(context,
                                        listen: false)
                                    .open();
                                Provider.of<CustomPanelController>(context,
                                        listen: false)
                                    .pageId = "inspector";
                              },
                              child: ListTile(
                                leading: Icon(Icons.insert_chart_outlined),
                                title: Text("Inspector"),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                Provider.of<SidePanelController>(context,
                                        listen: false)
                                    .open();
                                Provider.of<CustomPanelController>(context,
                                        listen: false)
                                    .pageId = "memory";
                              },
                              child: ListTile(
                                leading: Icon(Icons.table_rows_outlined),
                                title: Text("Memory"),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                Provider.of<SidePanelController>(context,
                                        listen: false)
                                    .open();
                                Provider.of<CustomPanelController>(context,
                                        listen: false)
                                    .pageId = "symtab";
                              },
                              child: ListTile(
                                leading: Icon(Icons.view_list_outlined),
                                title: Text("Symbols"),
                              ),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem(
                              onTap: () {
                                Provider.of<SidePanelController>(context,
                                        listen: false)
                                    .open();
                                Provider.of<CustomPanelController>(context,
                                        listen: false)
                                    .pageId = "help";
                              },
                              child: ListTile(
                                leading: Icon(Icons.help_outline),
                                title: Text("Help"),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SettingsPage(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                ));
                              },
                              child: ListTile(
                                leading: Icon(Icons.settings_outlined),
                                title: Text("Settings"),
                              ),
                            ),
                          ],
                        ),
                        SafeArea(
                          minimum: EdgeInsets.only(left: 8),
                          child: Container(),
                        ),
                      ],
                    ),
                    body: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        navigationRail,
                        Expanded(
                          child: NavigationPageView(),
                        ),
                        SidePanelWidget(
                          child: CustomPanelWidget(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
