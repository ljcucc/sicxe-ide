import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/navigation_page_view.dart';
import 'package:sicxe/providers.dart';
import 'package:sicxe/screen_size.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_controller.dart';
import 'package:sicxe/widgets/custom_panel/custom_panel_widget.dart';
import 'package:sicxe/widgets/horizontal_scroll_view.dart';
import 'package:sicxe/widgets/top_segmented_buttons/navigation_page_top_segmented.dart';

class CompactLayout extends StatelessWidget {
  const CompactLayout({
    super.key,
  });

  _openSidePanel(String id, context) {
    final emulator = Provider.of<EmulatorWorkflow>(context, listen: false);
    final editor = Provider.of<EditorWorkflow>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.only(top: 16.0),
            child: MultiProvider(
              providers: [
                Provider<ScreenSize>.value(
                  value: ScreenSize.Compact,
                ),
              ],
              child: Providers(
                emulator: emulator,
                editor: editor,
                customPanelController: CustomPanelController(pageId: id),
                child: const CustomPanelWidget(),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget menuBar() => SingleChildScrollView(
  //       padding: EdgeInsets.symmetric(horizontal: 16),
  //       scrollDirection: Axis.horizontal,
  //       child: Container(
  //         clipBehavior: Clip.antiAlias,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(14),
  //         ),
  //         child: Consumer<NavigationPageProvider>(
  //           builder: (context, npp, _) => NavigationPageTopSegmentedButtonGroup(
  //             pageId: npp.id,
  //           ),
  //         ),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationPageProvider>(
        builder: (context, navPageProvider, child) {
      final pageId = navPageProvider.id;
      final pageIndexMap = [
        NavigationPageId.Assets,
        NavigationPageId.Editor,
        NavigationPageId.Terminal,
        NavigationPageId.Timeline,
      ];

      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 80,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: HorizontalScrollView(
              child: NavigationPageTopSegmentedButtonGroup(
                pageId: pageId,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () {
                    _openSidePanel("inspector", context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.insert_chart_outlined),
                    title: Text("Inspector"),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    _openSidePanel("memory", context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.table_rows_outlined),
                    title: Text("Memory"),
                  ),
                ),
                PopupMenuDivider(),
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
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: NavigationPageView(),
                ),
                // menuBar(),
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
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.folder),
              label: "Assets",
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
              icon: Icon(Icons.graphic_eq),
              label: "Timeline",
            ),
          ],
        ),
      );
    });
  }
}
